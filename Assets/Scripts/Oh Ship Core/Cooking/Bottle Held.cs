using UnityEngine;

public class BottleHeld : MonoBehaviour, IHeldItem
{
    public void Use()
    {
        Debug.Log("Use Bottle");
    }
    public Transform GetTransform() => transform;
    public Vector3 GetPositionOffset() => Vector3.zero;
    public Quaternion GetRotationOffset() => Quaternion.identity;
    public GameObject GetAssociatedGameObject() => gameObject;
}
