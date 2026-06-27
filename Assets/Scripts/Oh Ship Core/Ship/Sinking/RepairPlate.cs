using System;
using System.Collections;
using UnityEngine;
[RequireComponent(typeof(Rigidbody))]
public class RepairPlate : MonoBehaviour
{
    Action m_onDespawn;
    Rigidbody m_rigidbody;
    [SerializeField] float m_timeUntilDespawn = 10;
    void Awake()
    {
        m_rigidbody = GetComponent<Rigidbody>();
    }
    public void Initialize(Vector3 position, Quaternion rotation, Action onDespawn)
    {
        m_rigidbody.isKinematic = true;
        m_rigidbody.position = position;
        m_rigidbody.rotation = rotation;
        m_onDespawn = onDespawn;
    }

    public void ShootPlateOffWall(Vector3 shootForce)
    {
        m_rigidbody.isKinematic = false;
        m_rigidbody.AddForce(shootForce, ForceMode.Impulse);
        StartCoroutine(Despawn());
    }

    IEnumerator Despawn()
    {
        yield return new WaitForSeconds(m_timeUntilDespawn);
        m_onDespawn?.Invoke();
    }
}
