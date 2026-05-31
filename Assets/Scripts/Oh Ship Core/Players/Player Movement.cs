using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

/// <summary>
/// Handle player movement through taking input from via <see cref="IPlayerControllable"/> from any <see cref="IPlayerController"/>
/// </summary>
public class PlayerMovement : MonoBehaviour, IPlayerControllable
{
    Rigidbody m_rigidbody;
    Vector2 m_desiredMovement;
    [SerializeField] InputActionAsset m_requiredInputAction;
    [SerializeField] float m_acceleration;
    [SerializeField] float m_deceleration;
    [SerializeField] float m_moveSpeed;
    [FormerlySerializedAs("cameraTurn")] [SerializeField] Transform m_camera;
    [FormerlySerializedAs("lookSens")] [SerializeField] float m_lookSensitivity = 30f;
    float m_lookPitch;
    Quaternion m_lookYaw = Quaternion.identity;
    Vector2 m_currentLookInput;
    
    void OnMovementInputChanged(InputAction.CallbackContext context) => m_desiredMovement = Vector2.ClampMagnitude(context.ReadValue<Vector2>(), 1) * m_moveSpeed;

    public void OnLookInputChanged(InputAction.CallbackContext context)
    {
        m_currentLookInput = context.ReadValue<Vector2>();
    }
    
    void Start()
    {
        m_rigidbody = GetComponent<Rigidbody>();
        m_camera = GetComponentInChildren<Camera>().transform;
    }

    void FixedUpdate()
    {
        Vector3 flattenedVelocity = new(m_rigidbody.linearVelocity.x, 0, m_rigidbody.linearVelocity.z);
        float forwardVelocity  = Vector3.Dot(m_lookYaw * Vector3.forward, flattenedVelocity);
        float sidewaysVelocity = Vector3.Dot(m_lookYaw * Vector3.right,   flattenedVelocity);
        Vector2 currentOrientedVelocity = new(sidewaysVelocity, forwardVelocity);
        float rateOfChange = currentOrientedVelocity.magnitude < m_desiredMovement.magnitude ? m_acceleration : m_deceleration;
        Vector2 newOrientedVelocity = Vector2.MoveTowards(currentOrientedVelocity, m_desiredMovement, rateOfChange * Time.fixedDeltaTime);
        Vector3 worldVelocity = m_lookYaw * new Vector3(newOrientedVelocity.x, 0, newOrientedVelocity.y);
        m_rigidbody.linearVelocity = new(worldVelocity.x, m_rigidbody.linearVelocity.y, worldVelocity.z);
    }

    void LateUpdate()
    {
        m_lookYaw *= Quaternion.Euler(0, m_currentLookInput.x * m_lookSensitivity * Time.deltaTime, 0);
        m_lookPitch = Mathf.Clamp(m_lookPitch - m_currentLookInput.y * m_lookSensitivity * Time.deltaTime, -90, 90);
        m_camera.rotation = m_lookYaw * Quaternion.Euler(m_lookPitch, 0, 0);
    }
    /// <inheritdoc/>
    public void OnControlRequested(IPlayerController player)
    {
        if (!player.ChangeInputActions(m_requiredInputAction))
        {
            Debug.LogError("Failed to assign input actions to player, reverting control to default.");
            player.ChangeControlledEntity(null);
            return;
        }

        m_requiredInputAction.Enable();

        InputAction movementAction = m_requiredInputAction.FindAction("Move");
        movementAction.performed += OnMovementInputChanged;
        movementAction.canceled += OnMovementInputChanged;

        InputAction lookAction = m_requiredInputAction.FindAction("Look");

        lookAction.performed += OnLookInputChanged;
        lookAction.canceled += OnLookInputChanged;
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
    }
}
