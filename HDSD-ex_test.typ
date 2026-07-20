// ============================================================
//  HƯỚNG DẪN SỬ DỤNG GÓI ex_test (dựa trên lib.typ / ex_test.typ)
//  File này biên dịch được độc lập, dùng để tra cứu + xem ví dụ
//  trực quan cho từng lệnh của gói.
// ============================================================

#import "style/lib.typ": *

#show: appearance
#show: tableofcontens

#set raw(block: true)
#show raw.where(block: true): it => {
  block(stroke: 1pt + red.darken(20%), fill: yellow.lighten(80%), radius: 3pt, inset: 8pt, width: 100%)[
    #it
  ]
}
#show raw.where(block: false): it => {
  box(stroke: none, fill: yellow.lighten(80%), radius: 5pt, inset: 4pt, width: auto)[
    #it
  ]
}

// Có thể bật/tắt hiển thị lời giải cho từng loại theorem
#state("vd_show_ans").update(true)
#state("bt_show_ans").update(true)
#state("ex_show_ans").update(true)
#state("btrl_show_ans").update(true)


#align(center)[
  #v(1fr)
  #text(size: 24pt, weight: "bold")[HƯỚNG DẪN SỬ DỤNG GÓI `ex_test`]
  #v(1fr)
  #text(style: "italic", size: 12pt)[
    Tài liệu dùng cho mã nguồn `ex_test.typ`.\
    Phiên bản gói: #ex_test_version — Tác giả: Phan Văn Anh\
    Github: https://github.com/vananh2801
  ]
  #v(2fr)
]

#heading("Lời cảm ơn", depth: 1, numbering: none)

Cảm ơn thầy Trần Anh Tuấn và thầy Dương Phước Sang vì đã tạo ra gói ex_test rất tuyệt vời, giúp việc gõ LaTeX gần gủi hơn cho GV dạy học.\
Dựa trên cơ sở ý tưởng của ex_test, tôi đã làm gói lệnh này, phục vụ cho việc gõ Typst trong dạy học.

#outline(depth: 3)

#chapter[Giới thiệu]

#section[Cấu trúc thư mục kiến nghị]

Dự án mẫu có cấu trúc như sau:

```
  project/
  ├── main.typ
  ├── style/
  │   ├── ex_test.typ
  │   └── lib.typ
  ├── data/
  │   └── 9D1-1.typ
  └── imgs/
```

Trong đó:
- `main.typ` là file chính của dự án dùng để khai báo `#import` và `#include`.
- `ex_test.typ` là phần cốt lõi của `ex_test`, định nghĩa cách một "theorem" (định nghĩa/ví dụ/bài tập...) hoạt động, cách trắc nghiệm lưu — xuất đáp án, cách danh sách tự chia cột, cách hình minh hoạ ghép với văn bản... \
  Thầy cô muốn có thể sửa để thay đổi theo nhu cầu của thầy cô, nhưng thường thì không cần thay đổi.
- `lib.typ` file dùng để cấu hình trang giấy, heading, footer,... Thầy cô có thể thay đổi theo sở thích cá nhân. Ngoài ra, trong file này còn có các khai báo như tạo theorem, cách các theorem hiển thị.

- File `9D1-1.typ` là ví dụ thực tế cách mà các theorem đã khai báo trong `lib.typ` được sử dụng.

#section[Khởi tạo file chính `main.typ`]

Ở đầu các file đuôi `.typ`, thầy cô cần khai báo:

```typ
#import "style/ex_test.typ"
```

Thật ra, nếu thầy cô xem kĩ các file mẫu sẽ thấy được rằng nếu trong `lib.typ` mà đã có dòng lệnh này thì khi thầy cô chạy lệnh `#import "style/lib.typ"` ở đầu các file thì đã đi kèm `ex_test` rồi.

== Các cấp tiêu đề

Gói `ex_test.typ` định nghĩa lại các cấp tiêu đề LaTeX quen thuộc như:

#align(center)[
  #table(
    columns: (auto, auto),
    stroke: 0.5pt + black,
    inset: 0.6em,
    align: left + horizon,
    table.header([*Lệnh*], [*Cấp tương đương bên Typst*]),
    [`#chapter[...]`], [=],
    [`#section[...]`], [==],
    [`#subsection[...]`], [===],
    [`#subsubsection[...]`], [====],
    [`#paragraph[...]`], [=====],
    [`#subparagraph[...]`], [======],
  )
]


Ví dụ:

```typ
#chapter[Phương trình bậc nhất hai ẩn]
#section[Khái niệm phương trình bậc nhất hai ẩn]
#subsection[Lý thuyết]
#subsubsection[Phương trình bậc nhất hai ẩn]
```

Khi sang Chương mới hoặc Bài mới, các bộ đếm `vd`, `bt`, `btrl`, `ex`... sẽ KHÔNG tự động reset về 0. Tuy nhiên gói lệnh `ex_test` đã tạo sẵn các counter. Nếu thầy cô muốn reset về 0 thì thầy cô phải chèn lệnh sau vào phần cấu hình heading:
```typ
#counter("<tên môi trường>_count").update(0)
```

Ví dụ:
```typ
#counter("ex_count").update(0)
#counter("bt_count").update(0)
#counter("vd_count").update(0)
```

Thầy cô có thể tham khảo `show heading.where(level: 1)` trong `lib.typ`.

#chapter[Tự tạo theorem]

#section[`createTheoremEx` -- thêm một theorem mới]

#subsection[Lệnh khai báo đầy đủ]

Để tạo một `theorem` mới để có thể dùng các chức năng của `ex_test`, thầy cô dùng lệnh `createTheoremEx` như sau:

```typ
#let <tên môi trường> = createTheoremEx(
  "<tên môi trường>",
  "<nhãn hiển thị của môi trường>",
  boxFunc: <tên hàm cấu hình khung>,
  contentFunc: <tên hàm cấu hình nội dung>,
  imminiFunc: <tên hàm cấu hình nhãn xuất hiện khi dùng #immini>,
  havingCounter: <dùng 'false' nếu muốn tạo theorem không đánh số>
)
```

#subsection[Khai báo cơ bản]

*Ví dụ minh hoạ khai báo cơ bản:*
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
)
```

*Ví dụ minh hoạ sử dụng:*
```typ
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]
```

*Kết quả trên PDF:*
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
)
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

#pagebreak()

#subsection[Tạo khung]

Khai báo khung cho Minh hoạ:

```typ
#let minhhoaBox(body) = {         // tên tuỳ ý
  block(
    width: 100%,                  // bề ngang hiện đủ 100% trang giấy
    radius: 6pt,                  // độ bo tròn
    inset: 1em,                   // khoảng cách giữa viền và nội dung
    fill: blue.lighten(90%),      // màu nền
    stroke: 1pt + blue,           // độ dày và màu viền
    breakable: true,              // cho phép ngắt giữa trang
  )[#body]
}
```

Khi đó ta khai báo như sau:
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxFunc: minhhoaBox,
)
```

*Kết quả khi sử dụng:*

#let minhhoaBox(body) = {
  // tên tuỳ ý
  block(
    width: 100%, // bề ngang hiện đủ 100% trang giấy
    radius: 6pt, // độ bo tròn
    inset: 1em, // khoảng cách giữa viền và nội dung
    fill: blue.lighten(90%), // màu nền
    stroke: 1pt + blue, // độ dày và màu viền
    breakable: true, // cho phép ngắt giữa trang
  )[#body]
}
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxFunc: minhhoaBox,
)
#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

#subsection[Thay đổi cấu trúc của nội dung bên trong]

Đôi khi ta muốn đưa nguồn bài tập xuống cạnh dưới bên phải khung thay vì in đậm ở phần nhãn, ta cần khai báo lại `imminiFunc` và `contentFunc`, chẳng hạn sau đây là khai báo cho Minh hoạ:

```typ
#let minhhoaContentFunc(body, fulllabel: none, shortlabel: none, label: none, subtitle: none, count: none) = [
  // In đậm Tiêu đề
  #strong[#shortlabel]
  // Xuất nội dung
  #body
  // Xuất nguồn đề bài in nghiêng
  #if subtitle != none {
    [#parbreak()#h(1fr)#emph[Nguồn: #subtitle]]
  }
]
```

```typ
#let minhoaImminiFunc(fulllabel: none, shortlabel: none, label: none, subtitle: none, count: none) = [
  #strong[#shortlabel]
]
```

Khi đó ta khai báo như sau:
```typ
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxFunc: minhhoaBox,
  contentFunc: minhhoaContentFunc,
  imminiFunc: minhoaImminiFunc
)
```

*Kết quả khi sử dụng:*
#let minhhoaContentFunc(body, fulllabel: none, shortlabel: none, label: none, subtitle: none, count: none) = [
  // In đậm Tiêu đề
  #strong[#shortlabel]
  // Xuất nội dung
  #body
  // Xuất nguồn đề bài in nghiêng
  #if subtitle != none {
    [#parbreak()#h(1fr)#emph[Nguồn: #subtitle]]
  }
]
#let minhoaImminiFunc(fulllabel: none, shortlabel: none, label: none, subtitle: none, count: none) = [
  #strong[#shortlabel]
]
#let minhhoa = createTheoremEx(
  "minhhoa",
  "Minh hoạ",
  boxFunc: minhhoaBox,
  contentFunc: minhhoaContentFunc,
  imminiFunc: minhoaImminiFunc,
)

#minhhoa(tieude: "Tên minh hoạ")[
  Đây là phần minh hoạ của cách sử dụng.
]

#v(5em)
*Lưu ý:* Để rõ hơn thầy cô xem ở cuối file `lib.typ`.

#section[`#immini` `#imminiL`  -- hình minh hoạ cho bài tập]

Dùng lệnh `#immini(<đề bài>, <hình ảnh>)` để xếp đề bài bên trái, hình bên phải.

Ngược lại, dùng `#imminiL` để xếp hình bên trái, đề bài bên phải.

*Ví dụ minh hoạ:*

```typ
#luuy[
  #immini[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #image("../imgs/minh-hoa.png", width: 6cm)
  ]
]
```
*Kết quả:*

#luuy[
  #immini[
    Toạ độ giao điểm của hai đường thẳng chính là nghiệm của hệ phương
    trình tương ứng.
  ][
    #rect(width: 6cm, height: 3.2cm, fill: blue.lighten(85%), radius: 4pt)[
      #align(center + horizon)[_(hình minh hoạ ở đây)_]
    ]
  ]
]

#section[`#loigiai` -- lời giải]

`#loigiai[...]` đặt bên trong một theorem (`vd`, `bt`, `btrl`, `ex`, `chc`,...) để chứa lời giải. Lệnh này *tự động* kiểm tra cấu hình `state("<ten>_show_ans")` để quyết định hiển thị lời giải hay thay bằng dòng kẻ chấm (nếu đã bật `dotlinefull`).

`#dotlineEX(n)`: in ra trực tiếp `n` dòng kẻ chấm (dùng ngay trong `loigiai`).

`#dotlinefull("bt", socot: 2)`: đặt ở đầu file, khiến *mọi* `loigiai` của `bt` tự động thay bằng dòng kẻ chấm với số dòng được tính tự động theo độ dài lời giải gốc, chia thành `socot` cột.

*Ví dụ minh hoạ 1:*

```typ
#bt[
  Đề bài...
  #loigiai[
    Hướng dẫn giải...
  ]
]
```

*Kết quả:*

#bt[
  Đề bài...
  #loigiai[
    Hướng dẫn giải...
  ]
]

*Ví dụ minh hoạ 2:*

```typ
#dotlineEX(3, socot: 2)
```

*Kết quả:*

#dotlineEX(3, socot: 2)

= Trắc nghiệm VÀ TỰ LUẬN

== `#choice` -- trắc nghiệm 4 phương án

- Tham số `socot`: ép số cột hiển thị 4 phương án (1, 2 hoặc 4). Nếu bỏ trống,
  package tự tính cột tối ưu theo độ rộng nội dung.
- `dapan: "B"`: khai báo nếu muốn xuất bảng đáp án tự động bằng `#XuatDapAn`
  (xem bên dưới).
- Nếu muốn thay các chữ cái A, B, C, D, thành số 1, 2, 3, 4 thì dùng `#choiceN`.
- Nếu chỉ truyền 1 phương án, `#choice` sẽ vẽ dạng `underbracket` đánh số
  A, B, C... tăng dần theo thứ tự xuất hiện (dùng cho trắc nghiệm tìm lỗi sai của môn Anh ngữ).

*Ví dụ minh hoạ 1:*

```typ
#ex[
  Phương trình nào sau đây KHÔNG là phương trình bậc nhất hai ẩn?
  #choice(
    [$x - 2y = 5$],
    [$0x + 0y = -3$],
    [$6x + 0y = 1$],
    [$0x - 4y = 3$],
    socot: 4,
    dapan: "B",
  )
  #loigiai[
    Đáp án B vì $a = b = 0$.
  ]
]
```

*Kết quả:*

#BatDauLuuDapAn("demo-tracnghiem")
#ex[
  Phương trình nào sau đây KHÔNG là phương trình bậc nhất hai ẩn?
  #choice(
    [$x - 2y = 5$],
    [$0x + 0y = -3$],
    [$6x + 0y = 1$],
    [$0x - 4y = 3$],
    dapan: "B",
  )
  #loigiai[
    Đáp án B vì $a = b = 0$.
  ]
]

*Ví dụ minh hoạ 2:*

```typ
#ex[
  Yoghurt, #choice[one of] the #choice[healthiest] snacks, #choice(dapan: "B")[are] adviced for people with #choice[daily] calcium needs.
]
```

*Kết quả:*

#ex[
  Yoghurt, #choice[one of] the #choice[healthiest] snacks, #choice(dapan: "B")[are] adviced for people with #choice[daily] calcium needs.
]

#section[`#choiceTF` -- trắc nghiệm Đúng/Sai]

- Mặc định sẽ không kẻ bảng, thêm tham số `kieu: "t"` để kẻ bảng.
- Khi không có tham số `kieu: "t"` sẽ in dạng danh sách chia cột như `#choice`. Nếu muốn chỉnh số cột thì thêm tham số `socot: 2`.
- Lệnh `#itemchoice` cũng có thể thêm tham số `socot: 2`.

*Ví dụ minh hoạ 1:*

```typ
#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    socot: 2
  )
  #loigiai[
    #itemchoice[
      + Đúng vì thoả $a != 0$.
      + Sai vì $a = b = 0$.
      + Đúng vì thoả $a != 0$.
      + Đúng vì thoả $b != 0$.
    ]
  ]
]
```

*Kết quả:*

#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    socot: 2,
  )
  #loigiai[
    #itemchoice[
      + Đúng vì thoả $a != 0$.
      + Sai vì $a = b = 0$.
      + Đúng vì thoả $a != 0$.
      + Đúng vì thoả $b != 0$.
    ]
  ]
]

#pagebreak()
*Ví dụ minh hoạ 2:*

```typ
#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    kieu: "t",
  )
  #loigiai[
    #itemchoice(socot: 2)[
      + Đúng vì thoả $a != 0$.
      + Sai vì $a = b = 0$.
      + Đúng vì thoả $a != 0$.
      + Đúng vì thoả $b != 0$.
    ]
  ]
]
```

*Kết quả:*

#ex[
  Phát biểu nào sau đây đúng/sai?
  #choiceTF(
    [Phương trình $x + y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $x + 0y = 1$ là bậc nhất hai ẩn],
    [Phương trình $0x + y = 0$ là bậc nhất hai ẩn],
    dapan: "Đ, S, Đ, Đ",
    kieu: "t",
  )
  #loigiai[
    #itemchoice(socot: 2)[
      + Đúng vì thoả $a != 0$.
      + Sai vì $a = b = 0$.
      + Đúng vì thoả $a != 0$.
      + Đúng vì thoả $b != 0$.
    ]
  ]
]

#section[`#shortans` -- câu trả lời ngắn]

Sử dụng tham số `kieu` để thay đổi kiểu in kết quả:
- `"..."`: hiện 1 dòng chấm ngắn.
- `"oly"`: hiện 4 ô vuông (mặc định).
- `"3"` một ô chữ nhật dài 3cm.

*Ví dụ minh hoạ:*

```typ
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "...")
]
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "oly")
]
#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "3")
]
```

*Kết quả:*

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "...")
]

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "oly")
]

#ex[
  Tổng hai nghiệm của phương trình... bằng bao nhiêu?
  #shortans("1234", kieu: "3")
]

#section[`#BatDauLuuDapAn`, `#KetThucLuuDapAn` và `#XuatDapAn` #linebreak()-- lưu và xuất bảng đáp án tự động]

*Cách dùng:*

```typ
#BatDauLuuDapAn("<tên bản sao lưu>")
#KetThucLuuDapAn("<tên bản sao lưu>")
#XuatDapAn(
  "<tên bản sao lưu>",
  socot: <số cột>,
  duongthang: <độ rộng đường thẳng> + <màu sắc>,
  botron: <độ bo tròn>,
  khoangcach: <khoảng cách giữa các ô>,
  nenmau: <màu nền của ô>,
)
```

*Ví dụ minh hoạ:*
```typ
#BatDauLuuDapAn("9D1-1-Tracnghiem")
#ex[ ... #choice(..., dapan: "B") ... ]
#ex[ ... #choice(..., dapan: "B") ... ]
#counter("ex_count").update(0) // reset bộ đếm
#ex[ ... #choiceTF(..., dapan: "Đ, S, Đ, Đ") ... ]
...
#KetThucLuuDapAn("9D1-1-Tracnghiem")

#XuatDapAn(
  "9D1-1-Tracnghiem",
  socot: 6,
  duongthang: 1pt + blue,
  nenmau: blue.lighten(95%)
)
```

#KetThucLuuDapAn("demo-tracnghiem")

*Kết quả:*

#XuatDapAn("demo-tracnghiem", socot: 6, duongthang: 1pt + blue, nenmau: blue.lighten(95%))

*Lưu ý:* Nếu có reset bộ đếm giữa chừng thì vẫn lưu đáp án theo đánh số của đề bài.

#section[`#dapso` -- đáp số vắn tắt cho bài toán tự luận]

*Ví dụ minh hoạ:*

```typ
#bt[
  Giải phương trình $2x = 6$.
  #dapso($x = 3$, hien: true)
  #loigiai[Hướng dẫn giải...]
]
```

*Kết quả: *

#bt[
  Giải phương trình $2x = 6$.
  #loigiai[Hướng dẫn giải...]
  #dapso($x = 3$, hien: true)
]

*Lưu ý:*
- Lệnh này sẽ không lưu lại kết quả.
- Dùng `#dapso_show_state.update(true)` ở `main.typ` nếu muốn hiện toàn bộ đáp số thay vì chỉnh tay từng câu.

#section[`ListEX` - môi trường danh sách]

Lệnh `listEX` dùng để lập danh sách thay cho `enum`, trong đó các ý của bài tập sẽ tự động dàn cột tương tự bên LaTeX (tối đa 4 cột). Nếu muốn chỉ định số cột cụ thể thì ta thêm tham số `socot`. Cấu trúc lệnh đầy đủ như sau:

```typ
#listEX(socot: <số cột>)[
  + Ý thứ nhất;
  + Ý thứ hai;
  + Ý thứ ba.
]
```

*Lưu ý:* Nếu số lượng ý nhỏ từ 26 ý trở xuống thì vẫn đánh bằng chữ cái. Ngược lại, nếu trên 26 thì sẽ chuyển sang đánh bằng số.

*Ví dụ minh hoạ:*

```typ
#listEX[
  + $x + 2y = 3$;
  + $0x + y = -2$;
  + $x + 0y = 3$.
]
```

*Kết quả:*

#listEX(socot: 3)[
  + $x + 2y = 3$;
  + $0x + y = -2$;
  + $x + 0y = 3$.
]
