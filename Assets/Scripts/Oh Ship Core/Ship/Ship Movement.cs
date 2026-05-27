using UnityEngine;

public class ShipMovement : MonoBehaviour
{
    [SerializeField, Range(-1 , 1)] float m_rudder;
    [SerializeField, Range(-1, 1)] float m_leftThrottle;
    [SerializeField, Range(-1, 1)] float m_rightThrottle;
    [SerializeField] Rigidbody m_rigidbody;
    [SerializeField] Transform m_leftWheelPowerPoint;
    [SerializeField] Transform m_rightWheelPowerPoint;
    [SerializeField] Transform m_rudderPoint;
    [SerializeField] AnimationCurve m_rudderEffectiveness;
    [SerializeField] AnimationCurve m_throttleEffectiveness;
    
    
    void FixedUpdate()
    {
        m_rigidbody.AddForceAtPosition(m_leftWheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(m_leftThrottle), m_leftWheelPowerPoint.position, ForceMode.Force);
        m_rigidbody.AddForceAtPosition(m_rightWheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(m_rightThrottle), m_rightWheelPowerPoint.position, ForceMode.Force);
        ApplyRudderForce(m_rudder);
    }

    void ApplyRudderForce(float rudderInput)
    {
        Vector3 flatForward = Vector3.ProjectOnPlane(m_rigidbody.transform.forward, Vector3.up).normalized;
        Vector3 flatRight = Vector3.ProjectOnPlane(m_rigidbody.transform.right, Vector3.up).normalized;
        float forwardSpeed = Vector3.Dot(m_rigidbody.linearVelocity, flatForward);
        float rudderEffectiveness = m_rudderEffectiveness.Evaluate(forwardSpeed);
        Vector3 rudderForce = flatRight * (rudderInput * rudderEffectiveness);
        m_rigidbody.AddForceAtPosition(rudderForce, m_rudderPoint.position, ForceMode.Force);
    }
}
