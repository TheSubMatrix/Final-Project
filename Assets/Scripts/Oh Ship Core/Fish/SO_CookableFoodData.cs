using UnityEngine;

[CreateAssetMenu(fileName = "SO_CookableFoodData", menuName = "Scriptable Objects/Food Data")]
public class SO_CookableFoodData : ScriptableObject
{
    [SerializeField] private GameObject model;
    [SerializeField] private SerializableDictionary<CookState, float> cookTimeThresholds;
    [SerializeField] private SerializableDictionary<CookState, float> hungerRestoreValue;
    [SerializeField] private float cookSpeed = .1f;
    
    
    public float GetThreshold(CookState cookState) => cookTimeThresholds.TryGetValue(cookState,out float value) ? value : -1f;
    public float HungerRestored(CookState cookState) => hungerRestoreValue.TryGetValue(cookState, out float value) ? value : -1f;
    public float CookSpeed => cookSpeed;
    public GameObject Model => model;
}
