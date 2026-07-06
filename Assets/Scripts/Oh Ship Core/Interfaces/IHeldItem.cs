using JetBrains.Annotations;
using UnityEngine;

public interface IHeldItem
{
    public void Use();
    [Pure] public Transform GetTransform();
    [Pure] public Vector3 GetPositionOffset();
    [Pure] public Quaternion GetRotationOffset();
}
