using UnityEngine;
using UnityEngine.InputSystem;

[CreateAssetMenu(fileName = "SO_CoalData", menuName = "Scriptable Objects/Coal Inputs")]
public class SO_CoalData : ScriptableObject
{
    [SerializeField] private string[] possibleInputs;
    
    public string[] PossibleInputs => possibleInputs;
}
