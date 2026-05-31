using UnityEngine;
using UnityEngine.Serialization;

public class ShipMovement : MonoBehaviour
{
    [field:SerializeField, Range(-1 , 1)]public float Rudder{ get; private set;}
    [field:SerializeField, Range(-1 , 1)]public float LeftThrottle{ get; private set;}
    [field:SerializeField, Range(-1 , 1)]public float RightThrottle{ get; private set;}

    [SerializeField] Rigidbody m_rigidbody;
    [SerializeField] Transform m_leftWheelPowerPoint;
    [SerializeField] Transform m_rightWheelPowerPoint;
    [SerializeField] Transform m_rudderPoint;
    [SerializeField] AnimationCurve m_rudderEffectiveness;
    [SerializeField] AnimationCurve m_throttleEffectiveness;
    public void SetRudder(float rudder) => Rudder = Mathf.Clamp(rudder, -1 , 1);
    public void SetThrottles(float leftThrottle, float rightThrottle)
    {
        LeftThrottle = Mathf.Clamp(leftThrottle, -1, 1);
        RightThrottle = Mathf.Clamp(rightThrottle, -1, 1);
    }
    
    void FixedUpdate()
    {
        m_rigidbody.AddForceAtPosition(m_leftWheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(LeftThrottle), m_leftWheelPowerPoint.position, ForceMode.Force);
        m_rigidbody.AddForceAtPosition(m_rightWheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(RightThrottle), m_rightWheelPowerPoint.position, ForceMode.Force);
        ApplyRudderForce(Rudder);
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
