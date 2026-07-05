using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Serialization;

public class HeldObjectLocation: MonoBehaviour
{
    public bool HasSomethingInHand => transform.childCount > 0;

    [FormerlySerializedAs("objectHoldConstraint"), RequiredField] public TwoBoneIKConstraint m_objectHoldConstraint;
    //This shouldn't be in update, but since there isn't any easy way to track when an object is picked up, this will work for now
    void Update()
    {
        m_objectHoldConstraint.weight = !HasSomethingInHand ? 0 : 1;
    }
    public void DestroyObjectsInHand()
    {
        foreach(Transform child in transform)
        {
            Destroy(child.gameObject);
        }
    }
    

        /*/| _ ╱|、
         ( •̀ㅅ •́ )
        ＿ノヽノ＼＿
        /　`/ ⌒Ｙ⌒ Ｙ\
      ( 　(三ヽ人　 /　|
        |　ﾉ⌒＼ ￣￣ヽノ
      ヽ＿＿＿＞､＿＿／
        ｜( 王 ﾉ〈
        /ﾐ`ー―彡\
     | ╰    ╯  |
     |     /\   |
     |    /  \  |
     |  /    \ |                  */
}
