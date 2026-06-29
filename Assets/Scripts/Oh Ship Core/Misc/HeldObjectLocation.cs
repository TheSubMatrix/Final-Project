using UnityEngine;

public class HeldObjectLocation: MonoBehaviour
{
    public bool hasSomethingInHand => transform.childCount > 0;

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
