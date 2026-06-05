using System.Collections.Generic;
using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.Pool;

public class ShipHealth : MonoBehaviour, IDamageable
{
    [SerializeField] List<Transform> m_holePositions;
    RandomBag<Transform> m_availableHoles;
    [SerializeField] ShipHole m_holePrefab;
    IObjectPool<ShipHole> m_shipHoles;
    [SerializeField, ReadOnly] float m_fillPercentage;
    uint m_holeCount;
    void Awake()
    {
        m_availableHoles = new(m_holePositions);
        m_shipHoles = new ObjectPool<ShipHole>
        (
            createFunc: () => Instantiate(m_holePrefab)
        );
    }
    void Update()
    {
        m_fillPercentage = Mathf.Clamp01(m_fillPercentage + m_holeCount * 0.5f * Time.deltaTime);
    }
    /// <inheritdoc/>
    public void Damage(uint amount)
    {
        for (uint i = 0; i < amount; i++)
        {
            if (m_availableHoles.Count == 0) return;
            m_holeCount++;
            Transform holeTransform = m_availableHoles.Take();
            ShipHole selectedHole = m_shipHoles.Get();
            selectedHole.Initialize(() =>
            {
                m_shipHoles.Release(selectedHole);
                m_holeCount--;
                m_availableHoles.Return(holeTransform);
                selectedHole.gameObject.SetActive(false);
            });
            selectedHole.transform.position = holeTransform.position;
            selectedHole.transform.rotation = holeTransform.rotation;
            selectedHole.gameObject.SetActive(true);
        }
    }
    
}