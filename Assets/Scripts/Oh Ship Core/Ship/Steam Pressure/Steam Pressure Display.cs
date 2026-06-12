using System;
using MatrixUtils.Attributes;
using MatrixUtils.Extensions;
using UnityEngine;
using UnityEngine.UI;

public class SteamPressureDisplay : MonoBehaviour
{
    [SerializeField, RequiredField] RectTransform m_steamPressureNeedle;
    [SerializeField, RequiredField] Slider m_steamAdjustmentSlider;
    [RequiredField] public CanvasGroup SteamPressureCanvasGroup;
    public event Action<float> OnSteamAdjustmentChanged = delegate { };

    void OnEnable() => m_steamAdjustmentSlider.onValueChanged.AddListener(OnSteamAdjustmentChanged.Invoke);
    void OnDisable() => m_steamAdjustmentSlider.onValueChanged.RemoveListener(OnSteamAdjustmentChanged.Invoke);

    public void UpdateCurrentSteamPressure(float steamPressure)
    {
        m_steamPressureNeedle.rotation = Quaternion.Euler(0, 0, steamPressure.Remap(0, 1, -90, 90));
    }
}
