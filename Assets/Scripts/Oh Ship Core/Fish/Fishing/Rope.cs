using System;
using System.Collections.Generic;
using MatrixUtils.Attributes;
using UnityEngine;

[RequireComponent(typeof(SpringJoint), typeof(Rigidbody), typeof(LineRenderer))]
public class Rope : MonoBehaviour
{
    Rigidbody m_startPoint;
    [SerializeField, RequiredField] Rigidbody m_endPoint;
    [SerializeField] float m_minimumLength = 0.5f;
    [SerializeField] float m_maximumLength = 5f;
    [SerializeField, Range(0, 1)] float m_currentLength = 0.5f;
    [SerializeField] float m_ropeDensity = 7750;
    [SerializeField] float m_ropeRadius = 0.02f;
    [SerializeField] float m_displayWidth = 0.05f;
    [SerializeField] uint m_segmentCount = 10;

    float CurrentLength => Mathf.Lerp(m_minimumLength, m_maximumLength, m_currentLength);

    SpringJoint m_springJoint;
    LineRenderer m_lineRenderer;
    SegmentedBezierCurve m_curve;

    void Start()
    {
        m_startPoint = GetComponent<Rigidbody>();
        m_springJoint = GetComponent<SpringJoint>();
        m_springJoint.connectedBody = m_endPoint;
        m_lineRenderer = GetComponent<LineRenderer>();
        m_lineRenderer.startWidth = m_displayWidth;
        m_lineRenderer.endWidth = m_displayWidth;

        Vector3 start = m_startPoint.position;
        Vector3 end = m_endPoint.position;
        m_curve = new SegmentedBezierCurve(start, start, end, end, m_segmentCount);
    }

    void FixedUpdate() => UpdateSimulation();

    void Update() => UpdateVisual();

    void UpdateSimulation()
    {
        float ropeForce = (m_ropeDensity * Mathf.PI * m_ropeRadius * m_ropeRadius * CurrentLength + m_endPoint.mass) * Physics.gravity.magnitude;
        float springConstant = ropeForce / 0.01f;
        m_springJoint.spring = springConstant;
        m_springJoint.damper = springConstant * 0.8f;
        m_springJoint.maxDistance = CurrentLength;
    }

    void UpdateVisual()
    {
        Vector3 start = m_startPoint.position;
        Vector3 end = m_endPoint.position;
        float span = (end - start).magnitude;
        m_curve.A.Value = start;
        m_curve.C.Value = end + m_endPoint.transform.up * (-span * 0.1f);
        m_curve.B.Value = start - m_startPoint.transform.up * (span * 0.5f);
        m_curve.D.Value = end;

        IReadOnlyList<Vector3> segments = m_curve.Segments;
        m_lineRenderer.positionCount = segments.Count;
        for (int i = 0; i < segments.Count; i++)
            m_lineRenderer.SetPosition(i, segments[i]);
    }


    public class SegmentedBezierCurve
    {
        public IReadOnlyList<Vector3> Segments => m_segments;
        readonly Vector3[] m_segments;
        readonly uint m_segmentCount;
        float SegmentLength => 1f / m_segmentCount;
        public CurveDefinitionPoint A, B, C, D;

        public SegmentedBezierCurve(Vector3 a, Vector3 b, Vector3 c, Vector3 d, uint segmentCount = 10)
        {
            m_segmentCount = segmentCount;
            m_segments = new Vector3[m_segmentCount + 1];
            A = new(a, UpdateAllSegments);
            B = new(b, UpdateAllSegments);
            C = new(c, UpdateAllSegments);
            D = new(d, UpdateAllSegments);
            UpdateAllSegments();
        }

        void UpdateAllSegments()
        {
            for (int i = 0; i < m_segmentCount; i++)
                m_segments[i] = DeCasteljausAlgorithm(A.Value, B.Value, C.Value, D.Value, i * SegmentLength);
            m_segments[m_segmentCount] = D.Value;
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
            }

            Action Update { get; }

            public Vector3 Value
            {
                get => m_value;
                set
                {
                    m_value = value;
                    Update?.Invoke();
                }
            }

            Vector3 m_value;
        }
    }
}