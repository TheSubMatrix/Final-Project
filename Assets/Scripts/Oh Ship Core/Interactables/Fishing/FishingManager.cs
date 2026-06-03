using System;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;
using UnityEngine.XR;

public class FishingManager : MonoBehaviour, IInteractable
{
    [SerializeField] private string _fishingControlActionMap = "Fishing";
    private RectTransform greenZone;
    private RectTransform playerFishingIcon;
    private Slider fishingProgressBar;
    private RectTransform usableFishingArea;
    [SerializeField] private float speedOfFishIcon;
    
    [Range(0f, 1f)]
    [SerializeField] private float progressSpeed;
    
    private bool _isHoldingButton = false;
    private float _minOfUsableFishingSpace;
    private float _maxOfUsableFishingSpace;
    private float _halfHeightOfFish;
    private FishingUI _fishingUI;
    private InputActionMap _activeActionMap;
    private InteractionSession _currentInteractionSession;
    private IPlayerController _playerController;
    
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        Debug.Log("Beginning Interaction");
        _playerController = interactor.GetAssociatedGameObject().transform.root.GetComponent<IPlayerController>();
       
        SetUpFishingMinigame(interactor);

        _currentInteractionSession = new InteractionSession(interactor, this);
        _currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(null);
        
        ChangeInputMaps();
        
        return _currentInteractionSession;
    }

    public InteractionSession EndInteraction(IInteractor interactor)
    {
        Debug.Log("Ending Interaction");
        _fishingUI.DisplayFishingUI();
        _fishingUI = null;
        
        return  new InteractionSession(interactor, this);
    }

    private void ChangeInputMaps()
    {
       // _playerController = playerController;
        
        Debug.Log(_playerController);

        if (!_playerController.ChangeInputActionMap(_fishingControlActionMap, out InputActionMap map))
        {
            Debug.LogError("Failed to assign input actions to player, reverting control to default.");
            _playerController.ChangeControlledEntity(null);
            return;
        }
        _activeActionMap = map;
        InputAction reelFishAction = _activeActionMap.FindAction("Reel Fish");
        reelFishAction.performed += HandleFishingInput;
        reelFishAction.canceled += HandleFishingInput;
        
        InputAction interactAction = _activeActionMap.FindAction("Interact");
        interactAction.performed += HandleInteract;

    }

    public void OnControlReleased()
    {
        _playerController = null;
        InputAction movementAction = _activeActionMap.FindAction("Reel Fish");
        movementAction.performed -= HandleFishingInput;
        movementAction.canceled -= HandleFishingInput;
        InputAction interactAction = _activeActionMap.FindAction("Interact");
        interactAction.performed -= HandleInteract;
        _activeActionMap = null;
    }

    private bool FishingIconOverlap(RectTransform fishIcon, RectTransform greenZone)
    {
        var (bottomOfFishIcon, topOfFishIcon) = GetMaxAndMinOfIcon(fishIcon);
        var (bottomOfGreenZoneIcon, topOfGreenZoneIcon) = GetMaxAndMinOfIcon(greenZone);
        
        
        
        if ((bottomOfGreenZoneIcon <= bottomOfFishIcon && topOfFishIcon <= topOfGreenZoneIcon))
        {
            Debug.Log("It's on!");
            return true;
        }
        return false;
    }

    private (float min, float max) GetMaxAndMinOfIcon(RectTransform incomingIcon)
    {
        Vector3[] worldCorners = new Vector3[4];
        incomingIcon.GetWorldCorners(worldCorners);

        return (worldCorners[0].y, worldCorners[1].y);
    }

    
    private void CheckFishingProgress(Slider incomingSlider)
    {

        if (FishingIconOverlap(playerFishingIcon, greenZone))
        {
            incomingSlider.value += progressSpeed * Time.deltaTime;
        }
        else
        {
            incomingSlider.value -= progressSpeed * Time.deltaTime;
        }
        incomingSlider.value = Mathf.Clamp(incomingSlider.value, 0f, 1f);
        
    }

    private void HandleInteract(InputAction.CallbackContext context) => _currentInteractionSession.End();


    private void HandleFishingInput(InputAction.CallbackContext context)
    {
        Debug.Log("Fishing Input Started");
        StartFishing(playerFishingIcon,usableFishingArea);
    }
    private void StartFishing(RectTransform incomingFishingIcon, RectTransform incomingUsableFishingSpace)
    {
        Debug.Log("Begun Reeling Fish");
        var (bottomOfFishArea, topOfFishArea) = GetMaxAndMinOfIcon(incomingUsableFishingSpace);
        
        float directionOfFish = _isHoldingButton ? speedOfFishIcon : -speedOfFishIcon;
        
        Vector3 worldPos = incomingFishingIcon.position;
        worldPos.y += directionOfFish * Time.deltaTime;
        worldPos.y = Mathf.Clamp(worldPos.y, 
            bottomOfFishArea + _halfHeightOfFish, 
            topOfFishArea - _halfHeightOfFish);
        
        incomingFishingIcon.position = worldPos;
    }

    private void SetUpUIElements(IInteractor interactor)
    {
        GameObject player = interactor.GetAssociatedGameObject().transform.root.gameObject;
        _fishingUI = player.GetComponentInChildren<FishingUI>();
        
        greenZone = _fishingUI.GreenZone;
        playerFishingIcon = _fishingUI.PlayerFishingIcon;
        fishingProgressBar = _fishingUI.FishingProgressBar;
        usableFishingArea = _fishingUI.UsableFishingArea;
        
        _fishingUI.DisplayFishingUI();
    }

    private void SetUpFishingMinigame(IInteractor interactor)
    {
        SetUpUIElements(interactor);
        
        (_minOfUsableFishingSpace,_maxOfUsableFishingSpace) = GetMaxAndMinOfIcon(usableFishingArea);
        var (bottomOfFishIcon, topOfFishIcon) = GetMaxAndMinOfIcon(playerFishingIcon);
        _halfHeightOfFish = (topOfFishIcon - bottomOfFishIcon) / 2;
    
        Vector3 startPos = playerFishingIcon.position;
        startPos.y = _minOfUsableFishingSpace + _halfHeightOfFish;
        playerFishingIcon.position = startPos;
        CheckFishingProgress(fishingProgressBar);
       
    }
}
