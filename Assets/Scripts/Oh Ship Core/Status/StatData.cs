using System;
using UnityEngine;
/// <summary>
/// A unique identifier for a stat to be applied retrieved from a <see cref="StatBlock"/> and modified by a <see cref="StatModifier"/>
/// </summary>
[CreateAssetMenu(fileName = "New Stat", menuName = "Scriptable Objects/Stat")]
public class StatData : ScriptableObject, IEquatable<StatData>
{
    /// <summary>
    /// The name of the stat
    /// </summary>
    [field:SerializeField] public string Name { get; protected set; }
    /// <summary>
    /// The icon of the stat
    /// </summary>
    [field:SerializeField] public Sprite Icon {get; protected set;}
    /// <summary>
    /// The unique identifier of the stat
    /// </summary>
    [field:SerializeField] public SerializableGuid GUID {get; private set;} = SerializableGuid.NewGuid();
    Guid ID => GUID.ToGuid();
    public bool Equals(StatData other) => other?.ID == ID;
    public override bool Equals(object obj) => obj is StatData other && Equals(other);
    public static bool operator ==(StatData a, StatData b) { return a?.GUID == b?.GUID; }
    public static bool operator !=(StatData a, StatData b) { return !(a == b); }
    public override int GetHashCode() => ID.GetHashCode();
}