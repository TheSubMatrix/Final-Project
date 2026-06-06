using System;
using UnityEngine;
/// <summary>
/// Handles the pressure of the steam in the ship, gets player input from <see cref="SteamPressureValveInteractable"/> and applies pressure to the ship which is handled by the ship via <see cref="ShipMovement"/>
/// </summary>
public class SteamPressureSystem : MonoBehaviour
{
    
    public float SteamPressure
    {
        get => _steamPressure;
        private set => _steamPressure = Mathf.Clamp(value, 0, 1);
    }
    
    private float _steamPressure = 1;
    
    [SerializeField] private float rateOfPressureLoss = 0.5f;


    private void Update()
    {
        SteamPressure -= rateOfPressureLoss * Time.deltaTime;
       
    }

    public void DecreaseSteamPressure(float amount)
    {
        SteamPressure -= amount;
        Debug.Log(_steamPressure);
    }
    
    public void IncreaseSteamPressure(float amount)
    {
        SteamPressure += amount;
        Debug.Log(_steamPressure);
    }
}
