import{c as k,a as s,f as p}from"./DcQL3t2F.js";import{f as c,s as f,c as B,n as j,r as q,t as u,b as a}from"./BwbreigZ.js";import{s as w}from"./DPdsL1Kv.js";import{e as A,i as D}from"./8THlvs0I.js";import{e as E}from"./C_YQg0J0.js";import{a as F,s as l,c as o,b as G}from"./qOonsEV7.js";import{p as H}from"./DI9baoaj.js";var I=p("<div></div>"),J=p("<div></div> <!> <div><!></div>",1);function S(_,t){let x=H(t,"tag",3,"div");const d=[{blur:1,gradient:[0,10,30,40]},{blur:2,gradient:[10,20,40,50]},{blur:4,gradient:[15,30,50,60]},{blur:8,gradient:[20,40,60,70]},{blur:12,gradient:[30,50,70,80]},{blur:16,gradient:[40,60,80,90]},{blur:24,gradient:[50,70,90,100]},{blur:32,gradient:[60,80]},{blur:64,gradient:[70,100]}];var n=k(),h=c(n);E(h,x,!1,(z,C)=>{F(z,()=>({class:t.class}),void 0,void 0,void 0,"svelte-xtcicm");var m=J(),v=c(m),b=f(v,2);A(b,17,()=>d,D,(P,e,T)=>{var i=I();let g;u(()=>{l(i,1,o(["blur-filter absolute top-0 left-0 size-full",{"z-10":T===d.length-1}]),"svelte-xtcicm"),g=G(i,`--pblur: ${a(e).blur??""}px`,g,{mask:`linear-gradient(
					${t.direction==="bottomToTop"?"to bottom":"to top"},
					rgba(0, 0, 0, 0) ${a(e).gradient[0]}%, 
					rgba(0, 0, 0, 1) ${a(e).gradient[1]}%${a(e).gradient.length===4?`,
						rgba(0, 0, 0, 1) ${a(e).gradient[2]}%, 
						rgba(0, 0, 0, 0) ${a(e).gradient[3]}%
					`:""} 
				);`})}),s(P,i)});var r=f(b,2),y=B(r);w(y,()=>t.children??j),q(r),u(()=>{l(v,1,o(["absolute top-0 left-0 size-full z-11",t.bgClass]),"svelte-xtcicm"),l(r,1,o(["relative z-12",t.contentClass]),"svelte-xtcicm")}),s(C,m)}),s(_,n)}export{S as P};
