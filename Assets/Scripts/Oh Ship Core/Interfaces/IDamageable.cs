/// <summary>
/// Represents an object that can be damaged
/// </summary>
public interface IDamageable
{
    /// <summary>
    /// Damages the object
    /// </summary>
    /// <param name="amount">The amount of damage to deal</param>
    void Damage(uint amount);
}
