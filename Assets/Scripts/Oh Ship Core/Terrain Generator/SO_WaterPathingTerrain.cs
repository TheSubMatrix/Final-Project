using UnityEngine; 
using MatrixUtils.GenericDatatypes;

[CreateAssetMenu(fileName = "WaterPathData", menuName = "Scriptable Objects/Terrain")]
public class SO_WaterPathingTerrain : ScriptableObject
{
    public SerializableDictionary<string, GameObject> possibleTiles = new();
}
