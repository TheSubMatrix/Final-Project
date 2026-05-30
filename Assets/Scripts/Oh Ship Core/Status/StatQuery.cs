public class StatQuery
{
    public readonly StatData Data;
    public float Value;
    public StatQuery(StatData data, float value)
    {
        Data = data;
        Value = value;
    }
}