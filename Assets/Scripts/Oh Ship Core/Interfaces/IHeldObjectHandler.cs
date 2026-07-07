public interface IHeldObjectHandler
{
    IHeldItem HeldItem { get; }
    bool TryHoldItem(IHeldItem item);
    bool TryDropItem();
}