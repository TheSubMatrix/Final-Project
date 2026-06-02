using UnityEditor;
using UnityEngine;
/// <summary>
/// Represents a rigidbody that buoys itself upwards when it reaches a certain height.
/// </summary>
[RequireComponent(typeof(Rigidbody))]
public class BuoyantBody : MonoBehaviour
{
    [SerializeField] float m_waterHeight;
    [SerializeField] BuoyancyPoint[] m_buoyancyPoints;
    Rigidbody m_rigidbody;
    
    void Start()
    {
        m_rigidbody = GetComponent<Rigidbody>();
    }
    void FixedUpdate()
    {
        foreach (BuoyancyPoint point in m_buoyancyPoints)
        {
            Vector3 globalPointPosition = transform.TransformPoint(point.LocalPosition);
            float depth = m_waterHeight - globalPointPosition.y;
            if (depth <= 0) continue;
            float submersion = Mathf.Clamp01(depth / point.Radius);
            m_rigidbody.AddForceAtPosition(Vector3.up * (submersion * point.PointBuoyancy * Physics.gravity.magnitude * m_rigidbody.mass), globalPointPosition);
            Vector3 pointVelocity = m_rigidbody.GetPointVelocity(globalPointPosition);
            Vector3 verticalVel = Vector3.Project(pointVelocity, Vector3.up);
            Vector3 longitudinalVel = Vector3.Project(pointVelocity, transform.forward);
            Vector3 lateralVel = pointVelocity - verticalVel - longitudinalVel;
            Vector3 drag = submersion * (verticalVel * point.Drag.y + longitudinalVel * point.Drag.x + lateralVel * point.Drag.z);
            m_rigidbody.AddForceAtPosition(-drag, globalPointPosition);
        }
    }
}
/// <summary>
/// Allows the user to edit the buoyancy points of a <see cref="BuoyantBody"/> in the scene.
/// </summary>
[CustomEditor(typeof(BuoyantBody))]
public class BuoyantBodyEditor : Editor
{

    public void OnSceneGUI()
    {
        serializedObject.Update();
        SerializedProperty buoyancyPoints = serializedObject.FindProperty("m_buoyancyPoints");
        Transform objectTransform = ((BuoyantBody)target).transform;
        for (int i = 0; i < buoyancyPoints.arraySize; i++)
        {
            SerializedProperty point = buoyancyPoints.GetArrayElementAtIndex(i).FindPropertyRelative("LocalPosition");
            Vector3 worldPosition = objectTransform.TransformPoint(point.vector3Value);
            float size = buoyancyPoints.GetArrayElementAtIndex(i).FindPropertyRelative("Radius").floatValue * 2;
            EditorGUI.BeginChangeCheck();
            Vector3 updatedPosition = Handles.FreeMoveHandle(worldPosition, size, Vector3.one * 0.1f, Handles.SphereHandleCap);
            if (!EditorGUI.EndChangeCheck()) continue;
            point.vector3Value = objectTransform.InverseTransformPoint(updatedPosition);
            serializedObject.ApplyModifiedProperties();
        }
    }
}