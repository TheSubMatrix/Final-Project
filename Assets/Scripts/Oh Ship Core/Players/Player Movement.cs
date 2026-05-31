using UnityEngine;
using UnityEngine.InputSystem;
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


    [SerializeField] private Transform cameraTurn;
    [SerializeField] private float lookSens = 30f;
    private Vector2 m_lookInput;
    private float pitch;
    Camera cam;

    void OnMovementInputChanged(InputAction.CallbackContext context) => m_desiredMovement = Vector2.ClampMagnitude(context.ReadValue<Vector2>(), 1) * m_moveSpeed;

    public void OnLookInputChanged(InputAction.CallbackContext context)
    {
        Debug.Log("Look callback fired");
        m_lookInput = context.ReadValue<Vector2>();
    }
    void Start()
    {
        m_rigidbody = GetComponent<Rigidbody>();
        cameraTurn = GetComponentInChildren<Camera>().transform;
    }

    void FixedUpdate()
    {
        Vector3 flattenedVelocity = new(m_rigidbody.linearVelocity.x, 0, m_rigidbody.linearVelocity.z);
        float forwardVelocity  = Vector3.Dot(Vector3.forward, flattenedVelocity);
        float sidewaysVelocity = Vector3.Dot(Vector3.right,   flattenedVelocity);
        Vector2 currentOrientedVelocity = new(sidewaysVelocity, forwardVelocity);
        float rateOfChange = currentOrientedVelocity.magnitude < m_desiredMovement.magnitude ? m_acceleration : m_deceleration;
        Vector2 newOrientedVelocity = Vector2.MoveTowards(currentOrientedVelocity, m_desiredMovement, rateOfChange * Time.fixedDeltaTime);
        m_rigidbody.linearVelocity = new(newOrientedVelocity.x, m_rigidbody.linearVelocity.y, newOrientedVelocity.y);

        transform.Rotate(Vector3.up, m_lookInput.x * lookSens * Time.fixedDeltaTime);
        pitch -= m_lookInput.y * lookSens * Time.fixedDeltaTime;
        pitch = Mathf.Clamp(pitch, -60f, 60f);
        cameraTurn.localRotation = Quaternion.Euler(pitch, 0, 0);
    }

    void Update()
    {
        Debug.Log("LOOK: " + m_lookInput);

        Debug.Log(m_requiredInputAction.enabled);
        Debug.Log(m_requiredInputAction.FindAction("Look").enabled);
        Debug.Log(m_requiredInputAction.FindAction("Look").actionMap.enabled);
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
