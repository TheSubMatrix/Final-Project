using UnityEngine;
[System.Serializable]
[CreateAssetMenu(fileName = "Lighting Preset", menuName = "Sciptables/Lighting Preset", order = 1)]

public class LightingPreset : ScriptableObject
{
    public Gradient ambientColor;
    public Gradient directionColor;
    public Gradient fogColor;
}
