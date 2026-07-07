using UnityEngine;
using UnityEngine.Serialization;

[CreateAssetMenu(fileName = "SO_CookableFoodData", menuName = "Scriptable Objects/Food Data")]
public class SO_CookableFoodData : ScriptableObject
{
    [FormerlySerializedAs("model")] [SerializeField] InterfaceReference<IHeldItem> m_itemToHold;
    [SerializeField] private SerializableDictionary<CookState, float> cookTimeThresholds;
    [SerializeField] private SerializableDictionary<CookState, float> hungerRestoreValue;
    [SerializeField] private float cookSpeed = .1f;
    
    
    public float GetThreshold(CookState cookState) => cookTimeThresholds.TryGetValue(cookState,out float value) ? value : -1f;
    public float HungerRestored(CookState cookState) => hungerRestoreValue.TryGetValue(cookState, out float value) ? value : -1f;
    public float CookSpeed => cookSpeed;
    public IHeldItem ItemToHold => m_itemToHold.Value;
}
