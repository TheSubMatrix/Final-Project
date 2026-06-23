using System;
using UnityEngine;
using UnityEngine.UI;

public class FishingUI : MonoBehaviour
{
    [SerializeField] private RectTransform greenZone;
    [SerializeField] private RectTransform fishingIcon;
    [SerializeField] private RectTransform usableFishingArea;
    [SerializeField] private Image fishingProgress;
    [SerializeField] private GameObject fishingUI;
    
    public RectTransform PlayerGreenZone => greenZone;
    public RectTransform FishingIcon => fishingIcon;
    public RectTransform UsableFishingArea => usableFishingArea;
    public Image FishingProgressBar => fishingProgress;

    private void Awake()
    {
       HideFishingUI();
    }

    public void DisplayFishingUI()
    {
        fishingUI.SetActive(true);
    }

    public void HideFishingUI()
    {
        fishingUI.SetActive(false);
    }
}