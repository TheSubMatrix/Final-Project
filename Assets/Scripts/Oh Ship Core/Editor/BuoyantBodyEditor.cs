#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;

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
#endif