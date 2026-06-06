using System;
using MatrixUtils.Attributes;
using UnityEngine;
/// <summary>
/// A simple radar system for a ship that uses a <see cref="ComputeShader"/> to render a render texture with radar data.
/// </summary>
public class ShipRadar : MonoBehaviour
{
    static readonly int s_uv = Shader.PropertyToID("_UV");
    static readonly int s_decayRate = Shader.PropertyToID("_DecayRate");
    static readonly int s_radarTexture = Shader.PropertyToID("_RadarTexture");
    [SerializeField, RequiredField] ComputeShader m_radarShader;
    [SerializeField, RequiredField] RenderTexture m_radarDataTexture;
    [SerializeField] float m_degreesPerSecond;
    [SerializeField] float m_maxDistance;
    [SerializeField] float m_decayRate;
    float m_sweepAngle;
    int m_decayKernel;
    int m_writeKernel;
    void Start()
    {
        m_decayKernel = m_radarShader.FindKernel("Decay");
        m_writeKernel = m_radarShader.FindKernel("WriteHit");
        m_radarShader.SetFloat(s_decayRate, m_decayRate);
        m_radarShader.SetTexture(m_decayKernel, s_radarTexture, m_radarDataTexture);
        m_radarShader.SetTexture(m_writeKernel, s_radarTexture, m_radarDataTexture);
    }
    void FixedUpdate()
    {
        m_sweepAngle += m_degreesPerSecond * Time.deltaTime;
        Vector3 direction = new(Mathf.Cos(m_sweepAngle * Mathf.Deg2Rad), 0, Mathf.Sin(m_sweepAngle * Mathf.Deg2Rad));
        m_radarShader.Dispatch(m_decayKernel, m_radarDataTexture.width / 8, m_radarDataTexture.height / 8, 1);
        if(!Physics.Raycast(transform.position, direction, out RaycastHit hit, m_maxDistance))
        {
            Debug.DrawRay(transform.position, direction * m_maxDistance, Color.red);
            return;
        }
        Debug.DrawRay(transform.position, direction * hit.distance, Color.green);
        Vector2 offset = new(hit.point.x - transform.position.x, hit.point.z - transform.position.z);
        Vector2 uv = (offset / m_maxDistance) * 0.5f + Vector2.one * 0.5f;
        m_radarShader.SetVector(s_uv, uv);
        m_radarShader.Dispatch(m_writeKernel, 1, 1, 1);
    }
}
