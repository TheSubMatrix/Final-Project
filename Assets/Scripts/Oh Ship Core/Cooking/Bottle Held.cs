using UnityEngine;

public class BottleHeld : MonoBehaviour, IHeldItem
{
    [SerializeField] Vector3 m_positionOffset;
    [SerializeField] Vector3 m_rotationOffset;
    public void Use()
    {
        Debug.Log("Use Bottle");
    }
    public Transform GetTransform() => transform;
    public Vector3 GetPositionOffset() => m_positionOffset;
    public Quaternion GetRotationOffset() => Quaternion.Euler(m_rotationOffset);
    public GameObject GetAssociatedGameObject() => gameObject;
    
}
