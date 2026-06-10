using MatrixUtils.GenericDatatypes;
using UnityEngine;

public class PlayerStatManager : MonoBehaviour
{
    [SerializeField] Observer<float> hunger = new Observer<float>();
    [SerializeField] Observer<float> thirst = new Observer<float>();
}
