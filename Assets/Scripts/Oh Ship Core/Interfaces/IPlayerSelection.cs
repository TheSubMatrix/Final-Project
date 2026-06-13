using UnityEngine;

public interface IPlayerSelection
{
    Transform Transform { get; }
    bool AllowsMultipleSelectors { get; }
    bool TryAddSelector(IPlayerControllable selector);
    bool TryRemoveSelector(IPlayerControllable selector);
    bool IsSelectedBy(IPlayerControllable selector);
    bool IsAvailableTo(IPlayerControllable selector);
}