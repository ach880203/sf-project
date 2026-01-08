package org.zerock.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ErrorPageController {

  @GetMapping("/error/403")
  public String e403() { return "error/403"; }

  @GetMapping("/error/404")
  public String e404() { return "error/404"; }

  @GetMapping("/error/405")
  public String e405() { return "error/405"; }

  @GetMapping("/error/500")
  public String e500() { return "error/500"; }
}
