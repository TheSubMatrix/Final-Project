#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using Object = UnityEngine.Object;

[CustomPropertyDrawer(typeof(InterfaceReference<>))]
[CustomPropertyDrawer(typeof(InterfaceReference<,>))]
public class InterfaceReferenceDrawer : PropertyDrawer {
    const string UnderlyingValueFieldName = "m_underlyingValue";

    public override VisualElement CreatePropertyGUI(SerializedProperty property)
    {
        VisualElement container = new();
        SerializedProperty underlyingProperty = property.FindPropertyRelative(UnderlyingValueFieldName);

        if (underlyingProperty == null) {
            container.Add(new Label($"Error: '{UnderlyingValueFieldName}' property not found"));
            return container;
        }

        InterfaceArgs args = GetInterfaceArguments(fieldInfo);
        if (!args.IsValid) {
            container.Add(new Label("Error: Invalid InterfaceReference configuration"));
            return container;
        }

        ObjectField objectField = new(property.displayName) {
            objectType = args.ObjectType,
            allowSceneObjects = true,
            value = underlyingProperty.objectReferenceValue
        };
        bool isUpdating = false;
        SerializedObject so = underlyingProperty.serializedObject;
        string path = underlyingProperty.propertyPath;

        SerializedProperty GetFreshProperty() {
            so.Update();
            return so.FindProperty(path);
        }

        objectField.RegisterValueChangedCallback(evt => {
            if (isUpdating) return;
            isUpdating = true;

            SerializedProperty prop = GetFreshProperty();
            if (prop != null) {
                HandleObjectAssignment(evt.newValue, prop, args, objectField);
            }

            isUpdating = false;
        });

        void OnUndoRedo(in UndoRedoInfo info) {
            if (so.targetObject == null) return;

            EditorApplication.delayCall += () => {
                if (so.targetObject == null) return;

                isUpdating = true;
                SerializedProperty prop = GetFreshProperty();

                if (prop != null) {
                    objectField.SetValueWithoutNotify(null);
                    objectField.value = prop.objectReferenceValue;
                    container.MarkDirtyRepaint();
                }

                isUpdating = false;
            };
        }

        Undo.undoRedoEvent += OnUndoRedo;
        container.RegisterCallback<DetachFromPanelEvent>(_ => {
            Undo.undoRedoEvent -= OnUndoRedo;
        });

        container.Add(objectField);
        container.Add(CreateInterfaceLabel(args.InterfaceType.Name, objectField));

        return container;
        }

    static void HandleObjectAssignment(Object assignedObject, SerializedProperty property, InterfaceArgs args, ObjectField field) {
        if (assignedObject == null) {
            property.objectReferenceValue = null;
            property.serializedObject.ApplyModifiedProperties();
            return;
        }

        Object validComponent = FindValidComponent(assignedObject, args.InterfaceType);

        if (validComponent != null) {
            property.objectReferenceValue = validComponent;
            property.serializedObject.ApplyModifiedProperties();
        } else {
            Debug.LogWarning($"Assigned object does not implement required interface '{args.InterfaceType.Name}'.");
            property.objectReferenceValue = null;
            property.serializedObject.ApplyModifiedProperties();
            field.SetValueWithoutNotify(null);
        }
    }

    static Object FindValidComponent(Object obj, Type interfaceType) {
        if (obj is GameObject gameObject) {
            return gameObject.GetComponent(interfaceType);
        }

        return interfaceType.IsAssignableFrom(obj.GetType()) ? obj : null;
    }

    static Label CreateInterfaceLabel(string interfaceName, ObjectField objectField) {
        Label label = new()
        {
            pickingMode = PickingMode.Ignore,
            style = {
                position = Position.Absolute,
                right = 20,
                top = 1,
                bottom = 1,
                unityTextAlign = TextAnchor.MiddleRight,
                paddingRight = 2,
                fontSize = 11,
                color = new Color(0.7f, 0.7f, 0.7f, 1f)
            }
        };

        UpdateLabel(false);
        objectField.RegisterCallback<MouseEnterEvent>(_ => UpdateLabel(true));
        objectField.RegisterCallback<MouseLeaveEvent>(_ => UpdateLabel(false));
        objectField.RegisterValueChangedCallback(_ => UpdateLabel(false));

        return label;

        void UpdateLabel(bool isHovering) {
	        label.text = objectField.value == null || isHovering ? $"({interfaceName})" : "*";
        }
    }

    static InterfaceArgs GetInterfaceArguments(FieldInfo fieldInfo) {
        Type fieldType = fieldInfo.FieldType;
        if (TryExtractFromInterfaceReference(fieldType, out Type objType, out Type interfaceType)) {
            return new(objType, interfaceType);
        }
        return TryExtractFromCollection(fieldType, out objType, out interfaceType) ? new InterfaceArgs(objType, interfaceType) : default;
    }

    static bool TryExtractFromInterfaceReference(Type type, out Type objectType, out Type interfaceType) {
        objectType = interfaceType = null;

        if (type?.IsGenericType != true) return false;
        Type genericDef = type.GetGenericTypeDefinition();
        if (genericDef == typeof(InterfaceReference<>))
        {
            type = type.BaseType;
        }
        if (type?.IsGenericType != true || type.GetGenericTypeDefinition() != typeof(InterfaceReference<,>)) return false;
        Type[] args = type.GetGenericArguments();
        interfaceType = args[0];
        objectType = args[1];
        return true;

    }

    static bool TryExtractFromCollection(Type type, out Type objectType, out Type interfaceType) {
        objectType = interfaceType = null;

        Type listInterface = type.GetInterfaces()
            .FirstOrDefault(x => x.IsGenericType && x.GetGenericTypeDefinition() == typeof(IList<>));

        if (listInterface == null) return false;
        Type elementType = listInterface.GetGenericArguments()[0];
        return TryExtractFromInterfaceReference(elementType, out objectType, out interfaceType);

    }
}
#endif