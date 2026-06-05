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

    [SerializeField] private float m_rudderTurnMultiplier = 10;
    public void SetRudder(float rudder) => Rudder = Mathf.Clamp(rudder, -1 , 1);
    public void SetThrottle(float throttle)
    {
        Throttle = Mathf.Clamp(throttle, -1, 1);
    }
    
    private SteamPressureSystem m_steamPressureSystem;
    private float m_steamPressure;

    void Start()
    {
         m_steamPressure = m_steamPressureSystem != null ? m_steamPressureSystem.SteamPressure : 0.5f;
        if (m_steamPressureSystem == null)
        {
            Debug.LogWarning("No SteamPressureSystem found on ship!");
        }
            
    }
    
    void FixedUpdate()
    {
        if (m_steamPressureSystem == null) return;
        
        m_rigidbody.AddForceAtPosition(m_wheelPowerPoint.forward * m_throttleEffectiveness.Evaluate(Throttle * 2) * (m_steamPressure + 0.5f), m_wheelPowerPoint.position, ForceMode.Force);
        ApplyRudderForce(Rudder);
    }

    void ApplyRudderForce(float rudderInput)
    {
        Vector3 flatForward = Vector3.ProjectOnPlane(m_rigidbody.transform.forward, Vector3.up).normalized;
        Vector3 flatLeft = Vector3.ProjectOnPlane(-m_rigidbody.transform.right, Vector3.up).normalized;
        float forwardSpeed = Vector3.Dot(m_rigidbody.linearVelocity, flatForward);
        float rudderEffectiveness = m_rudderEffectiveness.Evaluate(forwardSpeed);
        Vector3 rudderForce = flatLeft * (rudderInput * rudderEffectiveness);
        m_rigidbody.AddForceAtPosition(rudderForce * (m_rudderTurnMultiplier * 100), m_rudderPoint.position, ForceMode.Force);
        
    }
}
