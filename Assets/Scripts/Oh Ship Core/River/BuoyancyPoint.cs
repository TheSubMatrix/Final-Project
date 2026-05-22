using System;
using UnityEngine;
/// <summary>
/// Represents a point in a <see cref="BuoyantBody"/> where buoyancy is applied
/// </summary>
[Serializable]
internal struct BuoyancyPoint
{
    /// <summary>
    /// The minimum buoyancy that this point should have when in contact with the water
    /// </summary>
    public float m_minimumBuoyancy;
    /// <summary>
    /// The intensity of the buoyancy at this point. This will scale with how submerged the point is.
    /// </summary>
    public float m_pointBuoyancy;
    /// <summary>
    /// The local position of the point on the BuoyantBody
    /// </summary>
    public Vector3 m_localPosition;
}