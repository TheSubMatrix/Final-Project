using MatrixUtils.DependencyInjection;
using UnityEngine;

public class TransitionReadyUpProxy : MonoBehaviour
{
    [Inject] TransitionWhenReadiedUp m_transitionWhenReadiedUp;
    public void OnPlayerReadyUp() => m_transitionWhenReadiedUp.OnPlayerReadyUp();
    public void OnPlayerNotReadyUp() => m_transitionWhenReadiedUp.OnPlayerNotReadyUp();
}