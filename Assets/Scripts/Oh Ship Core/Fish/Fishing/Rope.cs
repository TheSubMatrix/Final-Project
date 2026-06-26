using System;
using System.Collections.Generic;
using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.Serialization;
[RequireComponent(typeof(SpringJoint), typeof(Rigidbody))]
public class Rope : MonoBehaviour
{
    Rigidbody m_startPoint;
    [SerializeField, RequiredField] Rigidbody m_endPoint;
    [SerializeField] float m_minimumLength = 0.5f;
    [SerializeField] float m_maximumLength = 5f;
    [SerializeField, Range(0,1)] float m_currentLength = 0.5f;
    [SerializeField] float m_ropeDensity = 7750;
    [SerializeField] float m_ropeRadius = 0.02f;
    float CurrentLength => Mathf.Lerp(m_minimumLength, m_maximumLength, m_currentLength);
    SpringJoint m_springJoint;
    
    void Start()
    {
        m_startPoint = GetComponent<Rigidbody>();
        m_springJoint = GetComponent<SpringJoint>();
        m_springJoint.connectedBody = m_endPoint;
    }
    void FixedUpdate() => UpdateSimulation();

    void UpdateSimulation()
    {
        float ropeForce = (m_ropeDensity * Mathf.PI * m_ropeRadius * m_ropeRadius * CurrentLength + m_endPoint.mass) * Physics.gravity.magnitude;
        float springConstant = ropeForce / 0.01f;
        m_springJoint.spring = springConstant;
        m_springJoint.damper = springConstant * 0.8f;
        m_springJoint.maxDistance = CurrentLength;
    }
    
    
    public class SegmentedBezierCurve
    {
        public IReadOnlyList<Vector3> Segments => m_segments;
        Vector3[] m_segments;
        readonly uint m_segmentCount;
        float SegmentLength => 1f / m_segmentCount;
        public CurveDefinitionPoint A, B, C, D;
        public SegmentedBezierCurve(Vector3 a, Vector3 b, Vector3 c, Vector3 d, uint segmentCount = 10)
        {
            A = new(a, UpdateAllSegments);
            B = new(b, UpdateAllSegments);
            C = new(c, UpdateAllSegments);
            D = new(d, UpdateAllSegments);
            m_segmentCount = segmentCount;
        }

        void UpdateAllSegments()
        {
            foreach (Vector3 segment in m_segments)
            {
                
            }
        }
        // ReSharper disable once IdentifierTypo
        static Vector3 DeCasteljausAlgorithm(Vector3 a, Vector3 b, Vector3 c, Vector3 d, float t)
        {
            Vector3 q = Vector3.Lerp(a, b, t);
            Vector3 r = Vector3.Lerp(b, c, t);
            Vector3 s = Vector3.Lerp(c, d, t);
            Vector3 p = Vector3.Lerp(q, r, t);
            Vector3 T = Vector3.Lerp(r, s, t);
            return Vector3.Lerp(p, T, t);
        }
        public struct CurveDefinitionPoint
        {
            public CurveDefinitionPoint(Vector3 start, Action update)
            {
                Update = update;
                m_value = start;
                Update();
            }
            Action Update { get; }
            public Vector3 Value
            {
                get => m_value;
                set
                {
                    m_value = value;
                    Update();
                }
            }
            Vector3 m_value;
        }
    }
}
