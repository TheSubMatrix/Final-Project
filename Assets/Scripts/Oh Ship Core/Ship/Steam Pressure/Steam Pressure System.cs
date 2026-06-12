using System;
using UnityEngine;
/// <summary>
/// Handles the pressure of the steam in the ship, gets player input from <see cref="SteamPressureValveInteractable"/> and applies pressure to the ship which is handled by the ship via <see cref="ShipMovement"/>
/// </summary>
public class SteamPressureSystem : MonoBehaviour
{
    public float SteamPressure
    {
        get => m_steamPressure;
        private set => m_steamPressure = Mathf.Clamp(value, 0, 1);
    }

    float m_steamPressure = 1;
    
    [SerializeField] float m_rateOfPressureLoss = 0.5f;


    private void Update()
    {
        SteamPressure -= m_rateOfPressureLoss * Time.deltaTime;
       
    }

    public void DecreaseSteamPressure(float amount)
    {
        SteamPressure -= amount;
        Debug.Log(m_steamPressure);
    }
    
    public void IncreaseSteamPressure(float amount)
    {
        SteamPressure += amount;
        Debug.Log(m_steamPressure);
    }
}
