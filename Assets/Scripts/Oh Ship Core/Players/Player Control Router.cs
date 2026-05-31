using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

public class PlayerControlRouter : MonoBehaviour, IPlayerControllable
{
    [SerializeField] InputActionAsset m_requiredInputAction;
    [SerializeField] UnityEvent<Vector2> m_onMovementInputChanged;
    [SerializeField] UnityEvent<Vector2> m_onLookInputChanged;
    [SerializeField] UnityEvent m_onInteract;
    void OnMovementInputChanged(InputAction.CallbackContext context) => m_onMovementInputChanged.Invoke(context.ReadValue<Vector2>());
    void OnLookInputChanged(InputAction.CallbackContext context) => m_onLookInputChanged.Invoke(context.ReadValue<Vector2>());
    void OnInteract(InputAction.CallbackContext context) => m_onInteract.Invoke();
    IPlayerController m_playerController;
    public void OnControlRequested(IPlayerController player)
    {
        if (!player.ChangeInputActions(m_requiredInputAction))
        {
            Debug.LogError("Failed to assign input actions to player, reverting control to default.");
            player.ChangeControlledEntity(null);
            return;
        }
        m_playerController = player;
        m_requiredInputAction.Enable();

        InputAction movementAction = m_requiredInputAction.FindAction("Move");
        movementAction.performed += OnMovementInputChanged;
        movementAction.canceled += OnMovementInputChanged;

        InputAction lookAction = m_requiredInputAction.FindAction("Look");
        lookAction.performed += OnLookInputChanged;
        lookAction.canceled += OnLookInputChanged;
        
        InputAction interactAction = m_requiredInputAction.FindAction("Interact");
        interactAction.performed += OnInteract;
    }
    /// <inheritdoc/>
    public void OnControlReleased()
    {
        m_requiredInputAction.Disable();

        InputAction movementAction = m_requiredInputAction.FindAction("Move");
        movementAction.performed -= OnMovementInputChanged;
        movementAction.canceled -= OnMovementInputChanged;

        InputAction lookAction = m_requiredInputAction.FindAction("Look");
        lookAction.performed -= OnLookInputChanged;
        lookAction.canceled -= OnLookInputChanged;
        
        InputAction interactAction = m_requiredInputAction.FindAction("Interact");
        interactAction.performed -= OnInteract;
        
        m_playerController = null;
    }
    /// <inheritdoc/>
    [System.Diagnostics.Contracts.Pure, CanBeNull]public IPlayerController GetActivePlayerController() => m_playerController;
}
