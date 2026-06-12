using UnityEngine;

[CreateAssetMenu(fileName = "New Player Colors", menuName = "Scriptable Objects/Player Colors")]
public class PlayerColors : ScriptableObject
{
    [field: SerializeField] public SerializableDictionary<int, Color> ColorMap { get; private set; } = new();
}
