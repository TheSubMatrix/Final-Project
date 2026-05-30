using System;
using UnityEngine;

[CreateAssetMenu(fileName = "New Stat", menuName = "Scriptable Objects/Stat")]
public class StatData : ScriptableObject, IEquatable<StatData>
{
    [field:SerializeField] public string Name { get; protected set; }
    [field:SerializeField] public Sprite Icon {get; protected set;}
    [field:SerializeField] public SerializableGuid GUID {get; private set;} = SerializableGuid.NewGuid();
    Guid ID => GUID.ToGuid();
    public bool Equals(StatData other) => other?.ID == ID;
    public override int GetHashCode() => ID.GetHashCode();
}