using System;
using UnityEngine;

using UnityEngine.UI;
using Random = System.Random;

public class FishingMiniGame
{
    private FishingMiniGameData _data;
    private float _halfHeightOfGreenPlayerIcon;
    private float _halfHeightOfFishIcon;
    public Action OnCaughtFish;
    
    private bool _isGameOver;

    private float _fishDirection;
    private float _fishSpeed;
   
    public void InitializeMiniGame(FishingMiniGameData fishingMiniGameData)
    {
        _isGameOver = false;
        _data = fishingMiniGameData;
        _data.FishingProgressBar.fillAmount = 0;
        var (bottomOfGreenZone, topOfGreenZone) = GetMaxAndMinOfIconLocal(_data.PlayerGreenZone);
        _halfHeightOfGreenPlayerIcon = (topOfGreenZone - bottomOfGreenZone) / 2;
        Debug.Log($"Green zone half height: {_halfHeightOfGreenPlayerIcon}, bottom: {bottomOfGreenZone}, top: {topOfGreenZone}");

        
        var (minOfUsableFishingSpace,maxOfUsableFishingSpace) = GetMaxAndMinOfIconLocal(_data.UsableFishingArea);
        Vector3 startPos = _data.PlayerGreenZone.localPosition;
        startPos.y = minOfUsableFishingSpace + _halfHeightOfGreenPlayerIcon;
        _data.PlayerGreenZone.localPosition = startPos;
        CheckFishingProgress(_data.FishingProgressBar);
        
        var(bottomOfFishIcon,topOfFishIcon) = GetMaxAndMinOfIconLocal(_data.FishingIcon);
        _halfHeightOfFishIcon = (topOfFishIcon - bottomOfFishIcon) / 2;
        _fishSpeed = UnityEngine.Random.Range(_data.FishMinSpeed, _data.FishMaxSpeed);
        _fishDirection = UnityEngine.Random.Range(minOfUsableFishingSpace + _halfHeightOfFishIcon,maxOfUsableFishingSpace - _halfHeightOfFishIcon);
    }
    
    public void UpdateMiniGame(bool isHoldingButton)
    {
        if(_data == null) return;
        PlayingMinigame(isHoldingButton);
        CheckFishingProgress(_data.FishingProgressBar);
        FishEscaping();
    }

    public void EndMiniGame()
    {
        _isGameOver = true;
    }

    public void FishEscaping()
    {
        if (_isGameOver) return;
        
        var (bottomOfFishArea, topOfFishArea) = GetMaxAndMinOfIconLocal(_data.UsableFishingArea);

        Vector3 localPos = _data.FishingIcon.localPosition;
        localPos.y = Mathf.MoveTowards(localPos.y, _fishDirection, _fishSpeed * Time.deltaTime);
        _data.FishingIcon.localPosition = localPos;

        if (Mathf.Approximately(localPos.y, _fishDirection))
        {
            _fishDirection = UnityEngine.Random.Range(bottomOfFishArea + _halfHeightOfFishIcon, topOfFishArea - _halfHeightOfFishIcon);
            _fishSpeed = UnityEngine.Random.Range(_data.FishMinSpeed, _data.FishMaxSpeed);
        }
    }

    public void PlayingMinigame(bool isHoldingButton)
    {
        if(_isGameOver) return;
        var (bottomOfFishArea, topOfFishArea) = GetMaxAndMinOfIconLocal(_data.UsableFishingArea);
        float directionOfFish = isHoldingButton ? _data.SpeedOfFishIcon : -_data.SpeedOfFishIcon;
        Vector3 localPos = _data.PlayerGreenZone.localPosition;
        localPos.y += directionOfFish * Time.deltaTime;       
       
        localPos.y = Mathf.Clamp(localPos.y, 
            bottomOfFishArea+ _halfHeightOfGreenPlayerIcon, 
            topOfFishArea - _halfHeightOfGreenPlayerIcon);
        
        _data.PlayerGreenZone.localPosition = localPos;
    }

    private void CheckFishingProgress(Image incomingSlider)
    {
        if(_isGameOver) return;
        
        if (FishingIconOverlap(_data.FishingIcon, _data.PlayerGreenZone))
        {
            incomingSlider.fillAmount += _data.ProgressSpeed * Time.deltaTime;
        }
        else
        {
            incomingSlider.fillAmount -= _data.ProgressSpeed * Time.deltaTime;
        }
        incomingSlider.fillAmount = Mathf.Clamp(incomingSlider.fillAmount, 0f, 1f);
        
        if (incomingSlider.fillAmount >= 1)
        {
            OnCaughtFish?.Invoke();
            EndMiniGame();
        }
        
    }
    
    private bool FishingIconOverlap(RectTransform fishIcon, RectTransform greenZone)
    {
        var (bottomOfFishIcon, topOfFishIcon) = GetMaxAndMinOfIconLocal(fishIcon);
        var (bottomOfGreenZoneIcon, topOfGreenZoneIcon) = GetMaxAndMinOfIconLocal(greenZone);
        
        if ((bottomOfGreenZoneIcon - _data.IconBuffer) <= bottomOfFishIcon && topOfFishIcon <= (topOfGreenZoneIcon + _data.IconBuffer))
        {
            return true;
        }
        return false;
    }
    
    private (float min, float max) GetMaxAndMinOfIconLocal(RectTransform incomingIcon)
    {
        Rect rect = incomingIcon.rect;
        
        float localY = incomingIcon.localPosition.y;
        return (localY + rect.yMin, localY + rect.yMax);
    }

    
}
