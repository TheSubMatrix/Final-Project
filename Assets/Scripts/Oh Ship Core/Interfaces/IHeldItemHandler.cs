using JetBrains.Annotations;
using UnityEngine;

public interface IHeldItemHandler
{
    IHeldItem HeldItem { get; }
    bool IsHoldingItem { get; }
    bool TryHoldItem(IHeldItem item);
    bool TryDropItem();
    bool TryClearHeldItem();
    [Pure] GameObject GetAssociatedGameObject();
}