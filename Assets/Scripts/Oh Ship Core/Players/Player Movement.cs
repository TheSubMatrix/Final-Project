using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;

/// <summary>
/// Handle player movement through taking input from via <see cref="IPlayerControllable"/> from any <see cref="IPlayerController"/>
/// </summary>
public class PlayerMovement : MonoBehaviour
{
    Rigidbody m_rigidbody;
    Vector2 m_desiredMovement;
    [SerializeField] float m_acceleration;
    [SerializeField] float m_deceleration;
    [SerializeField] float m_moveSpeed;
    [FormerlySerializedAs("cameraTurn")] [SerializeField] Transform m_camera;
    [FormerlySerializedAs("lookSens")] [SerializeField] float m_lookSensitivity = 30f;
    float m_lookPitch;
    Quaternion m_lookYaw = Quaternion.identity;
    Vector2 m_currentLookInput;
    IPlayerController m_playerController;
    public void OnMovementInputChanged(Vector2 input) => m_desiredMovement = Vector2.ClampMagnitude(input, 1) * m_moveSpeed;
    public void OnLookInputChanged(Vector2 input) => m_currentLookInput = input;

    void Start()
    {
        m_rigidbody = GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {
        Vector3 flattenedVelocity = new(m_rigidbody.linearVelocity.x, 0, m_rigidbody.linearVelocity.z);
        float forwardVelocity  = Vector3.Dot(m_lookYaw * Vector3.forward, flattenedVelocity);
        float sidewaysVelocity = Vector3.Dot(m_lookYaw * Vector3.right,   flattenedVelocity);
        Vector2 currentOrientedVelocity = new(sidewaysVelocity, forwardVelocity);
        
        bool isStopping = m_desiredMovement.sqrMagnitude < 0.001f;
        float rateOfChange = isStopping ? m_deceleration : m_acceleration;
        
        
       // float rateOfChange = currentOrientedVelocity.magnitude < m_desiredMovement.magnitude ? m_acceleration : m_deceleration;
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
}
