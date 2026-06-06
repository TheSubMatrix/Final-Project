using System;
using UnityEngine;
using UnityEngine.Serialization;

/// <summary>
/// Represents a point in a <see cref="BuoyantBody"/> where buoyancy is applied
/// </summary>
[Serializable]
internal struct BuoyancyPoint
{
    /// <summary>
    /// The intensity of the buoyancy at this point. This will scale with how submerged the point is.
    /// </summary>
    [FormerlySerializedAs("m_pointBuoyancy")] public float PointBuoyancy;
    /// <summary>
    /// The local position of the point on the BuoyantBody
    /// </summary>
    [FormerlySerializedAs("m_localPosition")] public Vector3 LocalPosition;
    /// <summary>
    /// The radius of the point. This will scale the buoyancy intensity with how submerged the point is.
    /// </summary>
    [FormerlySerializedAs("m_radius")] public float Radius;
    /// <summary>
    /// The drag force applied to the point on each axis at this point.
    /// </summary>
    public Vector3 Drag;
}