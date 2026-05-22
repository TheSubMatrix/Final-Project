using System.Collections.Generic;
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
            Vector3 globalPointPosition = transform.TransformPoint(point.m_localPosition);
            if (globalPointPosition.y > m_waterHeight) continue;
            m_rigidbody.AddForceAtPosition(((Mathf.Abs(globalPointPosition.y - m_waterHeight) * point.m_pointBuoyancy) + point.m_minimumBuoyancy) * Vector3.up, globalPointPosition);
        }
    }
}
[CustomEditor(typeof(BuoyantBody))]
public class BuoyantBodyEditor : Editor
{
    int m_selectedIndex = -1;

    public void OnSceneGUI()
    {
        serializedObject.Update();
        SerializedProperty buoyancyPoints = serializedObject.FindProperty("m_buoyancyPoints");
        Transform objectTransform = ((BuoyantBody)target).transform;
        for (int i = 0; i < buoyancyPoints.arraySize; i++)
        {
            SerializedProperty point = buoyancyPoints.GetArrayElementAtIndex(i).FindPropertyRelative("m_localPosition");
            Vector3 worldPosition = objectTransform.TransformPoint(point.vector3Value);
            Vector3 updatedPosition = worldPosition;
            bool isSelected = i == m_selectedIndex;
            float size = HandleUtility.GetHandleSize(worldPosition) * 0.3f;
            Handles.color = m_selectedIndex == i ? Color.yellow : Color.cyan;
            EditorGUI.BeginChangeCheck();
            if(isSelected)
            {
                updatedPosition = Handles.DoPositionHandle(worldPosition, Quaternion.identity);
                Handles.SphereHandleCap(0, worldPosition, Quaternion.identity, size, EventType.Repaint);
            }
            else if(Handles.Button(worldPosition, Quaternion.identity, size, size, Handles.SphereHandleCap)) m_selectedIndex = i;
            if (!EditorGUI.EndChangeCheck()) continue;
            point.vector3Value = objectTransform.InverseTransformPoint(updatedPosition);
            serializedObject.ApplyModifiedProperties();
        }
    }
}