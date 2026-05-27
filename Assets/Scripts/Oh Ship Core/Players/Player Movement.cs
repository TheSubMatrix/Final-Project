using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMovement : MonoBehaviour, IPlayerControllable
{
    Rigidbody m_rigidbody;
    Vector2 m_desiredMovement;
    [SerializeField] InputActionAsset m_requiredInputAction;
    [SerializeField] float m_acceleration;
    [SerializeField] float m_deceleration;
    [SerializeField] float m_moveSpeed;

    void OnMovementInputChanged(InputAction.CallbackContext context) => m_desiredMovement = Vector2.ClampMagnitude(context.ReadValue<Vector2>(), 1) * m_moveSpeed;
    void Start() => m_rigidbody = GetComponent<Rigidbody>();
    
    void FixedUpdate()
    {
        Vector3 flattenedVelocity = new(m_rigidbody.linearVelocity.x, 0, m_rigidbody.linearVelocity.z);
        float forwardVelocity  = Vector3.Dot(Vector3.forward, flattenedVelocity);
        float sidewaysVelocity = Vector3.Dot(Vector3.right,   flattenedVelocity);
        Vector2 currentOrientedVelocity = new(sidewaysVelocity, forwardVelocity);
        float rateOfChange = currentOrientedVelocity.magnitude < m_desiredMovement.magnitude ? m_acceleration : m_deceleration;
        Vector2 newOrientedVelocity = Vector2.MoveTowards(currentOrientedVelocity, m_desiredMovement, rateOfChange * Time.fixedDeltaTime);
        m_rigidbody.linearVelocity = new(newOrientedVelocity.x, m_rigidbody.linearVelocity.y, newOrientedVelocity.y);
    }

    public void OnControlRequested(IPlayerController player)
    {
        if (!player.ChangeInputActions(m_requiredInputAction))
        {
            Debug.LogError("Failed to assign input actions to player, reverting control to default.");
            player.ChangeControlledEntity(null);
            return;
        }
        InputAction movementAction = m_requiredInputAction.FindAction("Move");
        movementAction.performed += OnMovementInputChanged;
        movementAction.canceled += OnMovementInputChanged;
    }

    public void OnControlReleased()
    {
        InputAction movementAction = m_requiredInputAction.FindAction("Move");
        movementAction.performed -= OnMovementInputChanged;
        movementAction.canceled -= OnMovementInputChanged;
    }
}
