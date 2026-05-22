using System;
using UnityEngine;

[Serializable]
internal struct BuoyancyPoint
{
    public float m_minimumBuoyancy;
    public float m_pointBuoyancy;
    public Vector3 m_localPosition;
}