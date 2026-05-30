using System;

public abstract class StatModifier : IDisposable
{
    public bool MarkedForRemoval { get; private set; }
    public event Action<StatModifier> OnDisposed = delegate { };
    public abstract void Update(float deltaTime);
    public abstract void Handle(object sender, StatQuery query);
    public void Dispose()
    {
        if (MarkedForRemoval) return;
        MarkedForRemoval = true;
        OnDisposed(this);
    }
}