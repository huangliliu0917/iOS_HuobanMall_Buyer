var $pluginID="com.mob.sharesdk.QQ";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([3-79a-hk-mo-zA-Z]|[1-3]\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('9 23="auth://tauth.qq.1l/";9 u={"11":"app_id","12":"app_key","1e":"auth_type","1f":"covert_url"};9 24={"1Q":0,"1v":1};9 18={};b g(J){7.2t=J;7.t={"O":4,"G":4};7.1m=4;7.1n=4;7.1H=4}g.h.J=b(){w 7.2t};g.h.P=b(){w"g"};g.h.A=b(){6(7.t["G"]!=4&&7.t["G"][u.11]!=4){w 7.t["G"][u.11]}p 6(7.t["O"]!=4&&7.t["O"][u.11]!=4){w 7.t["O"][u.11]}w 4};g.h.1R=b(){6(7.t["G"]!=4&&7.t["G"][u.12]!=4){w 7.t["G"][u.12]}p 6(7.t["O"]!=4&&7.t["O"][u.12]!=4){w 7.t["O"][u.12]}w 4};g.h.1S=b(){6(7.t["G"]!=4&&7.t["G"][u.1e]!=4){w 7.t["G"][u.1e]}p 6(7.t["O"]!=4&&7.t["O"][u.1e]!=4){w 7.t["O"][u.1e]}w $3.5.1S()};g.h.25=b(){w"2u-2v-"+$3.5.k.g+"-"+7.A()};g.h.26=b(){6(7.t["G"]!=4&&7.t["G"][u.1f]!=4){w 7.t["G"][u.1f]}p 6(7.t["O"]!=4&&7.t["O"][u.1f]!=4){w 7.t["O"][u.1f]}w $3.5.26()};g.h.2w=b(1g){6(2x.1o==0){w 7.t["O"]}p{7.t["O"]=7.27(1g);7.28();7.29(7.A())}};g.h.2y=b(1g){6(2x.1o==0){w 7.t["G"]}p{9 19=7.27(1g);6(7.t["G"]==4){7.t["G"]={}}6(19[u.11]!=4){7.t["G"][u.11]=19[u.11]}6(19[u.12]!=4){7.t["G"][u.12]=19[u.12]}6(19[u.1e]!=4){7.t["G"][u.1e]=19[u.1e]}6(19[u.1f]!=4){7.t["G"][u.1f]=19[u.1f]}7.28();7.29(7.A())}};g.h.saveConfig=b(){9 e=7;9 1p="2u-2v";$3.H.2z("2A",1a,1p,b(a){6(a!=4){9 1I=a.1g;6(1I==4){1I={}}1I["plat_"+e.J()]=e.A();$3.H.2B("2A",1I,1a,1p,4)}})};g.h.isSupportAuth=b(){w 1w};g.h.2C=b(l,T){9 d=4;6(7.2D()){6(T==4){T={}}6(T["1x"]==4){T["1x"]=["2E","get_user_info","add_topic","upload_pic","add_share"]}9 e=7;7.2F(b(L,13){6(L){e.2G(l,13,T)}p{9 d={"r":$3.5.B.2H,"I":"分享平台［"+e.P()+"］尚未配置1T 1U:"+e.1n+"，无法进行授权!"};$3.E.Q(l,$3.5.f.q,d)}})}p{d={"r":$3.5.B.2a,"I":"分享平台［"+7.P()+"］应用信息无效!"};$3.E.Q(l,$3.5.f.q,d)}};g.h.2I=b(2b,c){9 e=7;7.1J(b(m){6(2b!=4){9 d={"r":$3.5.B.1V,"I":"分享平台［"+e.P()+"］不支持获取其他用户资料!"};6(c!=4){c($3.5.f.q,d)}w}e.2J("2c://openmobile.qq.1l/m/2E","2K",4,b(1b,a){9 U=a;6(1b==$3.5.f.1h){U={"2d":$3.5.k.1v,"1y":m.R.1y};e.2e(U,a);6(U["1y"]==m["1y"]){U["R"]=m["R"]}}6(c!=4){c(1b,U)}})})};g.h.2J=b(s,2L,V,c){9 d=4;9 e=7;7.1J(b(m){6(m!=4){6(V==4){V={}}V["oauth_consumer_key"]=e.A();6(m.R!=4){V["1K"]=m.R.1W;V["1L"]=m.R.1y}$3.H.2M($3.5.k.1v,4,s,2L,V,4,b(a){6(a!=4){6(a["r"]!=4){6(c){c($3.5.f.q,a)}}p{9 1i=$3.W.jsonStringToObject($3.W.2N(a["2O"]));6(a["2f"]==2P){6(c){c($3.5.f.1h,1i)}}p{9 2g=$3.5.B.X;1z(1i["r"]){K 100006:K 100007:K 100013:K 100014:K 100015:K 100016:K 100030:2g=$3.5.B.2Q;F}d={"r":2g,"14":1i};6(c){c($3.5.f.q,d)}}}}p{d={"r":$3.5.B.X};6(c){c($3.5.f.q,d)}}})}p{d={"r":$3.5.B.2Q,"I":"尚未授权["+e.P()+"]用户"};6(c){c($3.5.f.q,d)}}})};g.h.handleAuthCallback=b(l,Y){9 d=4;9 e=7;9 1X=$3.W.parseUrl(Y);6(1X!=4&&1X.2b!=4){9 V=$3.W.parseUrlParameters(1X.fragment);6(V!=4&&V.1K!=4){9 2R={"1K":V.1K};$3.H.2M($3.5.k.1v,4,"2c://2S.qq.1l/2T.0/me","2K",2R,4,b(a){6(a!=4){6(a["r"]!=4){$3.E.Q(l,$3.5.f.q,a)}p 6(a["2f"]!=4&&a["2f"]==2P){9 c=b(2U){w 2U};9 2V=$3.W.2N(a["2O"]);9 1i=eval(2V);6(1i.1L!=4){V["1L"]=1i.1L;e.1Y(l,V)}p{d={"r":$3.5.B.X,"14":1i};$3.E.Q(l,$3.5.f.q,d)}}p{d={"r":$3.5.B.X,"14":a};$3.E.Q(l,$3.5.f.q,d)}}p{d={"r":$3.5.B.X};$3.E.Q(l,$3.5.f.q,d)}})}p{d={"r":$3.5.B.2W,"I":"无效的授权回调:["+Y+"]"};$3.E.Q(l,$3.5.f.q,d)}}p{d={"r":$3.5.B.2W,"I":"无效的授权回调:["+Y+"]"};$3.E.Q(l,$3.5.f.q,d)}};g.h.handleSSOCallback=b(l,Y,2X,2Y){9 e=7;6(Y.2h(7.1n+"://")==0){$3.H.ssdk_qqHandlerSSOCallback(7.A(),Y,b(a){1z(a.1b){K $3.5.f.1h:{e.1Y(l,a.M);F}K $3.5.f.q:{9 d={"r":$3.5.B.X};$3.E.Q(l,$3.5.f.q,d);F}1M:$3.E.Q(l,$3.5.f.2i,4);F}});w 1w}w 1a};g.h.handleShareCallback=b(l,Y,2X,2Y){9 e=7;6(Y.2h(7.1n+"://")==0||Y.2h(7.1H+"://")==0){$3.H.ssdk_qqHandlerShareCallback(7.A(),Y,b(a){e.1J(b(m){9 S=18[l];9 N=4;9 y=4;6(S!=4){N=S["N"];y=S["14"]}1z(a.1b){K $3.5.f.1h:{9 U={};U["2j"]=N;U["o"]=N["o"];9 1Z=[];6(N["s"]){1Z.push(N["s"])}U["1Z"]=1Z;6(N["Z"]!=4){U["D"]=[N["Z"]]}p 6(N["1c"]!=4){U["D"]=[N["1c"]]}$3.E.2k(l,$3.5.f.1h,U,m,y);F}K $3.5.f.q:9 d={"r":$3.5.B.X,"14":{"r":a.r,"I":a.I}};$3.E.2k(l,$3.5.f.q,d,m,y);F;1M:$3.E.2k(l,$3.5.f.2i,4,m,y);F}delete 18[l];18[l]=4})});w 1w}w 1a};g.h.cancelAuthorize=b(){7.20(4,4)};g.h.addFriend=b(l,m,c){9 d={"r":$3.5.B.1V,"I":"平台["+7.P()+"]不支持添加好友方法!"};6(c!=4){c($3.5.f.q,d)}};g.h.getFriends=b(cursor,size,c){9 d={"r":$3.5.B.1V,"I":"平台["+7.P()+"]不支持获取好友列表方法!"};6(c!=4){c($3.5.f.q,d)}};g.h.share=b(l,v,c){9 e=7;9 21=v!=4?v["@21"]:4;9 y={"@21":21};$3.H.2l("1l.3.2m.2n.qq",b(a){6(a.M){$3.H.isMultitaskingSupported(b(a){6(a.M){e.2Z(b(L,13){6(L){e.30(l,v,y,c)}p{9 d={"r":$3.5.B.2H,"I":"尚未配置["+e.P()+"]1T 1U:"+e.1H+", 无法进行分享。"};6(c!=4){c($3.5.f.q,d,4,y)}}})}p{9 d={"r":$3.5.B.1V,"I":"应用已禁用后台模式，分享平台［"+e.P()+"］无法进行分享! 请在项目设置中开启后台模式后再试!"};6(c!=4){c($3.5.f.q,d,4,y)}}})}p{9 d={"r":$3.5.B.2a,"I":"分享平台［"+e.P()+"］尚未导入31.32!无法进行分享!"};6(c!=4){c($3.5.f.q,d,4,y)}}})};g.h.createUserByRawData=b(10){9 m={"2d":7.J()};7.2e(m,10);w $3.W.2o(m)};g.h.1A=b(2p,c){6(7.26()){9 e=7;7.1J(b(m){$3.5.convertUrl(e.J(),m,2p,c)})}p{6(c){c({"M":2p})}}};g.h._isUserAvaliable=b(m){w m.R!=4&&m.R.1W!=4&&m.R.33>34 35().36()};g.h.28=b(){7.1n=4;9 A=7.A();6(A!=4){7.1n="tencent"+A;9 1g=parseInt(7.A());9 1N=1g.1j(16).toUpperCase();while(1N.1o<8){1N="0"+1N}7.1H="g"+1N}};g.h.2D=b(){6(7.A()!=4&&7.1R()!=4){w 1w}$3.E.2q("#2r:["+7.P()+"]应用信息有误，不能进行相关操作。请检查本地代码中和服务端的["+7.P()+"]平台应用配置是否有误! \\n本地配置:"+$3.W.2o(7.2w())+"\\n服务器配置:"+$3.W.2o(7.2y()));w 1a};g.h.27=b(1B){9 A=$3.W.37(1B[u.11]);9 1R=$3.W.37(1B[u.12]);1B[u.11]=A;1B[u.12]=1R;w 1B};g.h.2F=b(c){9 e=7;$3.H.38(b(a){9 13=4;9 1C="";9 L=1a;9 1D=e.1n;6(a!=4&&a.1E!=4){22(9 i=0;i<a.1E.1o;i++){9 15=a.1E[i];6(15!=4&&15.1F!=4){22(9 j=0;j<15.1F.1o;j++){9 1G=15.1F[j];6(1G==1D){L=1w;13=1G;F}}}6(L){F}}}6(!L){1C=1D}6(!L){$3.E.2q("#2r:尚未配置["+e.P()+"]1T 1U:"+1C+", 无法使用SSO授权, 将以Web方式进行授权。")}6(c!=4){c(L,13)}})};g.h.2Z=b(c){9 e=7;$3.H.38(b(a){9 13=4;9 1C="";9 L=1a;9 1D=e.1H;6(a!=4&&a.1E!=4){22(9 i=0;i<a.1E.1o;i++){9 15=a.1E[i];6(15!=4&&15.1F!=4){22(9 j=0;j<15.1F.1o;j++){9 1G=15.1F[j];6(1G==1D){L=1w;13=1G;F}}}6(L){F}}}6(!L){1C=1D}6(!L){$3.E.2q("#2r:尚未配置["+e.P()+"]1T 1U:"+1C+", 无法进行分享。")}6(c!=4){c(L,13)}})};g.h._webAuthorize=b(l,T){9 2s="2c://2S.qq.1l/2T.0/2C?response_type=1W&client_id="+7.A()+"&redirect_uri="+$3.W.39(23);6(T!=4&&T["1x"]!=4&&1q.h.1j.1r(T["1x"])===\'[1s 1t]\'){2s+="&scope="+$3.W.39(T["1x"].join(","))}$3.E.ssdk_openAuthUrl(l,2s,23)};g.h.2G=b(l,13,T){9 e=7;9 1S=e.1S();$3.H.2l("1l.3.2m.2n.qq",b(a){6(a.M){$3.H.ssdk_qqAuth(e.A(),T["1x"],b(a){6(a.1b!=4){1z(a.1b){K $3.5.f.1h:{e.1Y(l,a.M);F}K $3.5.f.q:{$3.E.Q(l,$3.5.f.q,a.M);F}1M:$3.E.Q(l,$3.5.f.2i,4);F}}})}p{9 d={"r":$3.5.B.2a,"I":"分享平台［"+e.P()+"］尚未导入31.32!无法进行授权!"};$3.E.Q(l,$3.5.f.q,d)}})};g.h.1Y=b(l,1O){9 e=7;9 R={"1y":1O["1L"],"1W":1O["1K"],"33":(34 35().36()+1O["expires_in"]*1000),"2j":1O,"J":$3.5.credentialType.OAuth2};9 m={"2d":$3.5.k.g,"R":R};7.20(m,b(){e.2I(4,b(1b,a){6(1b==$3.5.f.1h){a["R"]=m["R"];m=a;e.20(m,4)}$3.E.Q(l,$3.5.f.1h,m)})})};g.h.20=b(m,c){7.1m=m;9 1p=7.25();$3.H.2B("3a",7.1m,1a,1p,b(a){6(c!=4){c()}})};g.h.1J=b(c){6(7.1m!=4){6(c){c(7.1m)}}p{9 e=7;9 1p=7.25();$3.H.2z("3a",1a,1p,b(a){e.1m=a!=4?a.1g:4;6(c){c(e.1m)}})}};g.h.2e=b(m,10){6(m!=4&&10!=4){m["2j"]=10;m["3b"]=10["3b"];m["icon"]=10["figureurl_2"];9 1u=2;6(10["1u"]=="男"){1u=0}p 6(10["1u"]=="女"){1u=1}m["1u"]=1u;m["verify_type"]=10["vip"]?1:0;m["3c"]=10["3c"]}};g.h.30=b(l,v,y,c){9 o=4;9 x=4;9 z=4;9 D=4;9 s=4;9 e=7;9 k=4;9 d=4;9 1d=v["qq_scene"];6(1d==4){1d=24.1Q}1z(1d){K 24.1v:k=$3.5.k.1v;F;1M:k=$3.5.k.1Q;F}9 J=$3.5.C(k,v,"J");6(J==4){J=$3.5.17.3d}6(J==$3.5.17.3d){J=7.3e(v,k)}1z(J){K $3.5.17.3f:{o=$3.5.C(k,v,"o");6(o!=4){7.1A([o],b(a){o=a.M[0];$3.H.ssdk_qqShareText(e.A(),1d,o,b(a){6(a.r!=4){6(c!=4){c($3.5.f.q,a,4,y)}}p{9 S={"1P":k,"o":o};18[l]={"N":S,"14":y}}})})}p{d={"r":$3.5.B.X,"I":"分享参数o不能为空!"};6(c!=4){c($3.5.f.q,d,4,y)}}F}K $3.5.17.3g:{o=$3.5.C(k,v,"o");x=$3.5.C(k,v,"x");z=$3.5.C(k,v,"Z");9 1c=4;D=$3.5.C(k,v,"D");6(1q.h.1j.1r(D)===\'[1s 1t]\'){1c=D[0]}6(1c!=4){7.1A([o],b(a){o=a.M[0];$3.H.ssdk_qqShareImage(e.A(),1d,x,o,z,1c,b(a){6(a.r!=4){6(c!=4){c($3.5.f.q,a,4,y)}}p{9 S={"1P":k,"o":o,"x":x,"Z":z,"1c":1c};18[l]={"N":S,"14":y}}})})}p{d={"r":$3.5.B.X,"I":"分享参数1c不能为空!"};6(c!=4){c($3.5.f.q,d,4,y)}}F}K $3.5.17.3h:{o=$3.5.C(k,v,"o");x=$3.5.C(k,v,"x");z=$3.5.C(k,v,"Z");6(z==4){D=$3.5.C(k,v,"D");6(1q.h.1j.1r(D)===\'[1s 1t]\'){z=D[0]}}s=$3.5.C(k,v,"s");6(x!=4&&z!=4&&s!=4){7.1A([o,s],b(a){o=a.M[0];s=a.M[1];$3.H.ssdk_qqShareWebpage(e.A(),1d,x,o,z,s,b(a){6(a.r!=4){6(c!=4){c($3.5.f.q,a,4,y)}}p{9 S={"1P":k,"o":o,"x":x,"Z":z,"s":s};18[l]={"N":S,"14":y}}})})}p{d={"r":$3.5.B.X,"I":"分享参数x、z、s不能为空!"};6(c!=4){c($3.5.f.q,d,4,y)}}F}K $3.5.17.Audio:{o=$3.5.C(k,v,"o");x=$3.5.C(k,v,"x");z=$3.5.C(k,v,"Z");6(z==4){D=$3.5.C(k,v,"D");6(1q.h.1j.1r(D)===\'[1s 1t]\'){z=D[0]}}s=$3.5.C(k,v,"s");6(x!=4&&z!=4&&s!=4){7.1A([o,s],b(a){o=a.M[0];s=a.M[1];$3.H.ssdk_qqShareAudio(e.A(),1d,x,o,z,s,b(a){6(a.r!=4){6(c!=4){c($3.5.f.q,a,4,y)}}p{9 S={"1P":k,"o":o,"x":x,"Z":z,"s":s};18[l]={"N":S,"14":y}}})})}p{d={"r":$3.5.B.X,"I":"分享参数x、z、s不能为空!"};6(c!=4){c($3.5.f.q,d,4,y)}}F}K $3.5.17.Video:{o=$3.5.C(k,v,"o");x=$3.5.C(k,v,"x");z=$3.5.C(k,v,"Z");6(z==4){D=$3.5.C(k,v,"D");6(1q.h.1j.1r(D)===\'[1s 1t]\'){z=D[0]}}s=$3.5.C(k,v,"s");6(x!=4&&z!=4&&s!=4){7.1A([o,s],b(a){o=a.M[0];s=a.M[1];$3.H.ssdk_qqShareVideo(e.A(),1d,x,o,z,s,b(a){6(a.r!=4){6(c!=4){c($3.5.f.q,a,4,y)}}p{9 S={"1P":k,"o":o,"x":x,"Z":z,"s":s};18[l]={"N":S,"14":y}}})})}p{d={"r":$3.5.B.X,"I":"分享参数x、z、s不能为空!"};6(c!=4){c($3.5.f.q,d,4,y)}}F}1M:{d={"r":$3.5.B.UnsupportContentType,"I":"不支持的分享类型["+J+"]"};6(c!=4){c($3.5.f.q,d,4,y)}F}}};g.h.29=b(A){6(A!=4){$3.H.2l("1l.3.2m.2n.qq",b(a){6(a.M){$3.E.ssdk_plugin_qq_setup(A)}})}};g.h.3e=b(v,k){9 J=$3.5.17.3f;9 x=$3.5.C(k,v,"x");9 z=$3.5.C(k,v,"Z");9 s=$3.5.C(k,v,"s");9 D=$3.5.C(k,v,"D");6(x!=4&&(z!=4||1q.h.1j.1r(D)===\'[1s 1t]\')&&s!=4){J=$3.5.17.3h}p 6(1q.h.1j.1r(D)===\'[1s 1t]\'&&k==$3.5.k.1Q){J=$3.5.17.3g}w J};$3.5.registerPlatformClass($3.5.k.g,g);',[],204,'|||mob|null|shareSDK|if|this||var|data|function|callback|error|self|responseState|QQ|prototype|||platformType|sessionId|user||text|else|Fail|error_code|url|_appInfo|QQAppInfoKeys|parameters|return|title|userData|thumbImage|appId|errorCode|getShareParam|images|native|break|server|ext|error_message|type|case|hasReady|result|content|local|name|ssdk_authStateChanged|credential|shareParams|settings|resultData|params|utils|APIRequestFail|callbackUrl|thumb_image|rawData|AppID|AppKey|urlScheme|user_data|typeObj||contentType|QQShareContentSet|newServerConf|false|state|image|scene|AuthType|ConvertUrl|value|Success|response|toString||com|_currentUser|_authUrlScheme|length|domain|Object|apply|object|Array|gender|QZone|true|scopes|uid|switch|_convertUrl|appInfo|warningLog|callbackScheme|CFBundleURLTypes|CFBundleURLSchemes|schema|_shareUrlScheme|curApps|_getCurrentUser|access_token|openid|default|str|credentialRawData|platform|QQFriend|appKey|authType|URL|Scheme|UnsupportFeature|token|urlInfo|_succeedAuthorize|urls|_setCurrentUser|flags|for|QQRedirectUri|QQScene|cacheDomain|convertUrlEnabled|_checkAppInfoAvailable|_updateCallbackURLSchemes|_setupApp|InvaildPlatform|query|https|platform_type|_updateUserInfo|status_code|code|indexOf|Cancel|raw_data|ssdk_shareStateChanged|isPluginRegisted|sharesdk|connector|objectToJsonString|contents|log|warning|authUrl|_type|SSDK|Platform|localAppInfo|arguments|serverAppInfo|getCacheData|currentApp|setCacheData|authorize|_isAvailable|get_simple_userinfo|_checkUrlScheme|_ssoAuthorize|UnsetURLScheme|getUserInfo|callApi|GET|method|ssdk_callHTTPApi|base64Decode|response_data|200|UserUnauth|getOpenIDParams|graph|oauth2|obj|responseString|InvalidAuthCallback|sourceApplication|annotation|_checkShareUrlScheme|_share|TencentOpenApi|framework|expired|new|Date|getTime|trim|getAppConfig|urlEncode|currentUser|nickname|level|Auto|_getShareType|Text|Image|WebPage'.split('|'),0,{}))