using System.Collections;
using System.Collections.Generic;
using UnityEngine;
 
public class LiquidWobble : MonoBehaviour
{
    static readonly int s_wobbleX = Shader.PropertyToID("_X_Wobble");
    static readonly int s_wobbleZ = Shader.PropertyToID("_Z_Wobble");
    Renderer m_rend;
    Vector3 m_lastPos;
    Vector3 m_velocity;
    Vector3 m_lastRot;
    Vector3 m_angularVelocity;
    public float MaxWobble = 0.03f;
    public float WobbleSpeed = 1f;
    public float Recovery = 1f;
    float m_wobbleAmountX;
    float m_wobbleAmountZ;
    float m_wobbleAmountToAddX;
    float m_wobbleAmountToAddZ;
    float m_pulse;
    float m_time = 0.5f;
    
    // Use this for initialization
    void Start()
    {
        m_rend = GetComponent<Renderer>();
    }

    void Update()
    {
        if(Time.timeScale <= 0) return;
        m_time += Time.deltaTime;
        // decrease wobble over time
        m_wobbleAmountToAddX = Mathf.Lerp(m_wobbleAmountToAddX, 0, Time.deltaTime * (Recovery));
        m_wobbleAmountToAddZ = Mathf.Lerp(m_wobbleAmountToAddZ, 0, Time.deltaTime * (Recovery));
 
        // make a sine wave of the decreasing wobble
        m_pulse = 2 * Mathf.PI * WobbleSpeed;
        m_wobbleAmountX = m_wobbleAmountToAddX * Mathf.Sin(m_pulse * m_time);
        m_wobbleAmountZ = m_wobbleAmountToAddZ * Mathf.Sin(m_pulse * m_time);
 
        // send it to the shader
        m_rend.material.SetFloat(s_wobbleX, m_wobbleAmountX);
        m_rend.material.SetFloat(s_wobbleZ, m_wobbleAmountZ);
 
        // velocity
        m_velocity = (m_lastPos - transform.position) / Time.deltaTime;
        m_angularVelocity = transform.rotation.eulerAngles - m_lastRot;
 
 
        // add clamped velocity to wobble
        m_wobbleAmountToAddX += Mathf.Clamp((m_velocity.x + (m_angularVelocity.z * 0.2f)) * MaxWobble, -MaxWobble, MaxWobble);
        m_wobbleAmountToAddZ += Mathf.Clamp((m_velocity.z + (m_angularVelocity.x * 0.2f)) * MaxWobble, -MaxWobble, MaxWobble);
 
        // keep last position
        m_lastPos = transform.position;
        m_lastRot = transform.rotation.eulerAngles;
    }
 
 
 
}