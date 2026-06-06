using System;
using MatrixUtils.Attributes;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.InputSystem;

public class HelmInteractable : MonoBehaviour, IInteractable, IPlayerControllable
{
    [SerializeField] string m_helmControlActionMap = "Helm";
    [SerializeField] CinemachineCamera m_helmCamera;
    [SerializeField] float m_helmThrottleSpeed = 0.5f;
    [SerializeField] float m_helmRudderSpeed = 0.5f;
    [SerializeField, RequiredField] ShipMovement m_shipMovement;
    IPlayerController m_activePlayerController;
    Vector2 m_input = Vector2.zero;
    InputActionMap m_activeActionMap;
    InteractionSession m_currentInteractionSession;
    ///<inheritdoc/>
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        if(interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;   
        IPlayerControllable oldControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        CinemachineCamera playerCam = interactor.GetAssociatedGameObject().GetComponent<CinemachineCamera>();
        m_helmCamera.OutputChannel = playerCam.OutputChannel;
        m_helmCamera.Priority = 10;
        IPlayerController controller = oldControllable.GetActivePlayerController();
        controller.ChangeControlledEntity(this);
        m_currentInteractionSession = new(interactor, this);
        m_currentInteractionSession.OnEnded += () => controller.ChangeControlledEntity(oldControllable); 
        return m_currentInteractionSession;
    }

    void Update()
    {
        if(m_activePlayerController is null) return;
        m_shipMovement.SetRudder(m_shipMovement.Rudder + m_input.x * Time.deltaTime * m_helmRudderSpeed);
        m_shipMovement.SetThrottle(m_shipMovement.Throttle + m_input.y * Time.deltaTime * m_helmThrottleSpeed);
    }
    ///<inheritdoc/>
    public void OnControlRequested(IPlayerController player)
    {
        m_activePlayerController = player;
        if (!player.ChangeInputActionMap(m_helmControlActionMap, out InputActionMap map))
        {
            Debug.LogError("Failed to assign input actions to player, reverting control to default.");
            player.ChangeControlledEntity(null);
            return;
        }
        m_activeActionMap = map;
        InputAction movementAction = m_activeActionMap.FindAction("Move");
        movementAction.performed += HandleMovementInput;
        movementAction.canceled += HandleMovementInput;
        InputAction interactAction = m_activeActionMap.FindAction("Interact");
        interactAction.performed += HandleInteract;
    }
    ///<inheritdoc/>
    public void OnControlReleased()
    {
        m_input = Vector2.zero;
        m_helmCamera.Priority = 0;
        Update();
        if (!m_activePlayerController.GetCurrentInputActionMap(out InputActionMap map)) return;
        InputAction movementAction = m_activeActionMap.FindAction("Move");
        movementAction.performed -= HandleMovementInput;
        movementAction.canceled -= HandleMovementInput;
        InputAction interactAction = m_activeActionMap.FindAction("Interact");
        interactAction.performed -= HandleInteract;
        m_activeActionMap = null;
        m_activePlayerController = null;
    }
    ///<inheritdoc/>
    public IPlayerController GetActivePlayerController() => m_activePlayerController;

    void HandleMovementInput(InputAction.CallbackContext context) => m_input = context.ReadValue<Vector2>();
    void HandleInteract(InputAction.CallbackContext context) => m_currentInteractionSession.End();

    public GameObject GetAssociatedGameObject()
    {
        return gameObject;
    }
}
