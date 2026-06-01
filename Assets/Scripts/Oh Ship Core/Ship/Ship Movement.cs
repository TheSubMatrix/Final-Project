using UnityEngine;
using UnityEngine.Serialization;

public class ShipMovement : MonoBehaviour
{
    [field:SerializeField, Range(-1 , 1)]public float Rudder{ get; private set;}
    [field:SerializeField, Range(-1 , 1)]public float Throttle{ get; private set;}

    [SerializeField] Rigidbody m_rigidbody;
    [SerializeField] Transform m_wheelPowerPoint;
    [SerializeField] Transform m_rudderPoint;
    [SerializeField] AnimationCurve m_rudderEffectiveness;
    [SerializeField] AnimationCurve m_throttleEffectiveness;
    public void SetRudder(float rudder) => Rudder = Mathf.Clamp(rudder, -1 , 1);
    public void SetThrottle(float throttle)
    {
        Throttle = Mathf.Clamp(throttle, -1, 1);
    }
    
    void FixedUpdate()
    {
        m_rigidbody.AddForceAtPosition(m_wheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(Throttle), m_wheelPowerPoint.position, ForceMode.Force);
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
