using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.InputSystem;

public class HelmInteractable : MonoBehaviour, IInteractable, IPlayerControllable
{
    [SerializeField] string m_helmControlActionMap = "Helm";
    
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
        IPlayerControllable oldControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
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
        Update();
        m_activePlayerController = null;
        InputAction movementAction = m_activeActionMap.FindAction("Move");
        movementAction.performed -= HandleMovementInput;
        movementAction.canceled -= HandleMovementInput;
        InputAction interactAction = m_activeActionMap.FindAction("Interact");
        interactAction.performed -= HandleInteract;
        m_activeActionMap = null;
    }
    ///<inheritdoc/>
    public IPlayerController GetActivePlayerController() => m_activePlayerController;

    void HandleMovementInput(InputAction.CallbackContext context) => m_input = context.ReadValue<Vector2>();
    void HandleInteract(InputAction.CallbackContext context) => m_currentInteractionSession.End();
}
