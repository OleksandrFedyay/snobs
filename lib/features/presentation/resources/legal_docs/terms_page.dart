import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

@RoutePage()
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      body: Stack(
        children: <Widget>[
          _buildBackground(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.scale(
          scale: 1.5,
          child: ClipOval(
            child: Container(
              height: height / 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    lightColorScheme.main.withValues(alpha:.3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          SizedBox(height: padding.top),
          _buildAppBar(),
          Text(
            context.i10n.termsConditions,
            style: context.textStyle.labelLarge,
          ),
          const SizedBox(height: 30),
          Text(
            r'''
Effective Date April 17, 2024

Kingfisher Digital (the "Website", “Company”, “us”, “we”, or “our”) has developed these Terms and Conditions. These Terms and Conditions (“Terms”) and any supplements or amendments to it, together with our Privacy Policy (collectively, the “Agreement”) form a legally binding agreement between you (“you”,“your”,or “user”) and the Company, its directors, officers, parents, subsidiaries and representatives. This Agreement governs your access to and use of any - Company Website or application, collectively or individually referred to as “Platform”,  and your use or attempted use of our products and services. Continued use of or access to the Platform shall be deemed to constitute your consent to be bound by the terms of this Agreement and shall be enforceable in the same way as if it was signed by you. Company grants you a non-exclusive, non-sublicensable, non-transferable, revocable, limited right to use the Platform strictly in accordance with this Agreement. You may only use the Platform on a device that You own or control. 

Notice of Agreement to Arbitrate and Class Action Waiver
By accepting these Terms, you agree to the agreement to arbitrate and class action waiver contained in Section 5 of these Terms below.


Contents
1. Eligibility
2. Intellectual Property
3. Usage Restriction
4. Links to Affiliate Websites
5. User Data 
6. Conditions related to deals.
7. Paid Membership
8. In-App Currency
9. Termination of  Account
10. Disclaimer
10. Agreement to Arbitrate
11. Consent to Contact
12. Voice Recording and Monitoring Consent
13. DMCA Policy and notice 
14. Limitation on Liability
15. Indemnification
16. Modifications to the Agreement
17. Miscellaneous

1. ELIGIBILITY
Our Platform is intended for users who are 18 years or older and are eligible to enter into a legally binding contract with us and not be barred from doing so under any applicable laws; or for users who are 13 years or older and have your parent or guardian's consent to the Agreement. The Platform is not intended for children under 18 years of age. By using the Platform, you are affirming that you are at least 18 years old.

This Platform is intended for users residing in the contiguous United States, Alaska, and Hawaii.



2. INTELLECTUAL PROPERTY
You acknowledge that content available through the Platform, including but not limited to content in the form of text, graphics, logos, software, music, videos, sounds and photographs as well as the content provided by suppliers, sponsors, or third-party advertisers, is protected by copyright, trademarks, patents, or other proprietary rights and applicable laws ("Intellectual Property Rights"). We grant you a non-exclusive, non-sublicensable, non-transferable, revocable, limited license to view, copy and print content retrieved from the Platform solely for using or placing an order through the Platform, provided that you agree not to remove or conceal the copyright notice or any other notices displayed on the content of the Platform. Unless expressly stated in this Agreement, nothing contained in this Agreement or on the Platform shall be construed as conferring any other rights or license, expressly, by implication, by estoppel, or otherwise under any of Company’s or a third party's Intellectual Property Rights. Any rights not expressly granted herein are reserved. 
The Company may implement algorithms or methodologies to rank artists or content based on various criteria. You acknowledge that the ranking results are subjective and reflect Platform’s proprietary algorithms.

Audio previews and full song radio features within the Snobs app are powered by Rebelation. All music content provided through Rebelation is subject to copyright laws and is provided for personal, non-commercial use only.

3. USAGE RESTRICTION. Unless expressly stated in this Agreement, you agree not to (i) store transmit, upload, circulate, or otherwise make available any files that may contain malicious technology or material, including without limitation, viruses, logic bombs trojans or worms; (ii) determine or attempt to determine the source code, algorithms, or systems and procedures incorporated by the Platform; (iii) hinder or attempt to hinder the proper functioning of the Platform, disrupt the Platform and/or any networks connected to the Platform, or bypass any restrictive or preventive measures to access the Platform; (iv) remove, obscure, or alter any proprietary notices included in the original content or material of the Platform; (v) use automated scripts to wrongfully collect information from or otherwise connect with the Platform; (vi) edit, modify, adapt, translate, make unauthorized copies, disassemble, reverse engineer, decompile or create derivative works of the Platform; (vii) sell, resell, distribute, license, transfer the Platform (in whole or in part); and (viii) violate any law or the terms of this Agreement; (ix) use the Platform in a manner that offends common decency in particular refers to pornography, content that is harmful to minor, or glorifies violence, propaganda material of anti-constitutional organisations and parties, weapons, drugs or other products that pose a risk to consumer safety; (x) use the Platform or any of its features, in whole or in part, for any unlawful activity or to promote or condone any such activity. 

4. LINKS TO AFFILIATE WEBSITES
Our Platform may contain links to affiliate websites offering services and/or products and the Company may earn a small commission, without any cost to you, if you click on links to such affiliate websites from our Platform and thereafter make a purchase on their website(s).The Platform offers affiliate links to third party websites to provide a good user experience. Please note that we do not verify the identity and/or ascertain the credibility of third-party affiliates, check, inspect, monitor, or manage the security of third party affiliate websites nor do we verify, authenticate or monitor the accuracy and exhaustiveness of the information made accessible on such third-party affiliate websites. You agree that we shall not be held responsible or liable for any damage or loss arising out of your use of a third-party affiliate website(s), any information contained or provided by, or any offer(s) made by such website(s), or any contract between you and a third-party affiliate. We are not accountable for the enforcement of any obligations resulting from a contract between you and any third-party affiliate and shall not be obligated to intervene between the parties to any such contract. You expressly agree and accept that you will not involve us in any legal proceeding(s), investigation(s), audit(s) or arbitration deployed to resolve any and all disagreements between you and such third party affiliates.

Advertisements 
The Platform may engage in advertising partnerships and collaborations with third-party advertisers. You agree and acknowledge that the Platform may display advertisements and promotional content, and the Platform reserves the right to determine the types and formats of advertisements displayed. You agree that we shall not be held responsible or liable for any damage or loss arising out of your use of any products or services from such advertisements or promotions. 

5. USER DATA 
You acknowledge and agree that our Platform may collect, process, store and may use certain personal information and data provided by the User during the registration and usage of the Platform. The company shall handle such data in accordance with applicable privacy laws and its Privacy Policy. 

6. CONDITIONS RELATED TO DEALS
To access samples, deals, giveaways, coupons, sweepstakes or any other offers (“Deals”) through the links available on the Platform you may be required to share your personal information, respond to survey questions and agree to be contacted by our marketing partners. The Company does not guarantee the availability of any and all Deal(s) facilitated through our Platform or that they will meet your requirements since they are offered as well as monitored by third parties and are provided on Platform for convenience purposes only. We shall not be held responsible for the unavailability of or your inability to access/redeem any Deals, offered by third-parties, for any reasons including but not limited to, third-party terms and conditions subject to which such Deals may be available, qualification criteria associated with or related to such Deals (for example- geographic constraints, products or service suitability as per age, etc.), denial of service by such third-parties, communication lapses or any other reasons due to which the Deals become unavailable. In case of Sweepstakes organized by the Platform, additional terms & conditions applicable to such sweepstakes or contests shall be governed by the Sweepstake Rules of the Company.

Please be informed that we do not review, validate, authorize, or endorse any Deals rendered by such third parties. When you click on any link(s) associated with such Deal(s), embedded on the Platform, you will leave the environment of the Platform and be re-routed to the corresponding third-party website. Such third-party websites may collect personal and non-personal information about you and your use of their website. Your use of or contact with any third-party website or Deals offered on such websites shall be regulated by their respective policies. We encourage you to read the terms of service and privacy policies of such respective third parties. You agree and accept that we shall not be a party to any contract between you and any third-party concerning such Deal(s) and that we shall neither be required nor obligated to carry out any obligations attributed to you or the third-party under such a contract between you and such third-party. You further agree and accept that you will not involve us in any legal proceeding(s), investigation(s), audit(s), arbitration or other procedures deployed to resolve any and all disagreements between you and such third party.

The Company and its agents assume no responsibility for any consequence relating directly or indirectly to any action or inaction you take based on the information, services, or other material on the Platform. While the Company strives to keep the information on the Platform accurate, complete, and up-to-date, it cannot guarantee, and will not be responsible for any damage or loss related to the accuracy, completeness or timeliness of the information on the Platform.

7. PAID MEMBERSHIP
The Platform may offer paid membership plans that provide Users with additional benefits, privileges, and access to exclusive content and features. By subscribing to the paid membership plan, Users agree to comply with the terms and conditions governing the respective plan. The Platform reserves the right to update membership plans, pricing, and benefits, and will communicate any modifications to the Users. You may cancel your membership at any time by sending an email to info@kingfishergo.com. You acknowledge that the membership fees are not refundable. 

8. IN-APP CURRENCY
The Platform may incorporate an In-app currency or virtual tokens that you can earn, purchase or utilise within the Platform. It will have no real world value and is solely intended for use within the Platform. The currency will be the property of the Platform and does not represent any tangible or transferable asset. You acknowledge that the currency cannot be exchanged, sold, transferred, or redeemed for real world currency, goods or services. 

The Platform reserves the right to modify, suspend, or terminate the currency, in whole or in part, at its sole discretion, without prior notice or liability to You. Such modifications or terminations may include, but are not limited to, adjusting the exchange rate, availability, functionality, or other aspects of the Currency. You agree not to engage in any unauthorized activity or attempt to manipulate, exploit, or disrupt the algorithms or mechanisms responsible for the generation, distribution, or management of the Currency within the Platform. 

9. TERMINATION OF ACCOUNT 

If you are in breach of any of these terms, we reserve the right, in our sole discretion, to terminate your right to access the Platform. We are not responsible for any loss, damage or harm related to your inability to access or use the Platform based on such termination. 

10. Disclaimer of Warranties
The Platform is provided on an “as is” and “as available” basis. Unless specifically provided in the Terms, we expressly disclaim any and all warranties of any kind, whether express or implied, including, without limitation, any warranties of merchantability, fitness for a particular purpose and non-infringement and any other warranty arising under the uniform commercial code, usage of trade, course of conduct or otherwise to the fullest extent permitted by law,

Without limiting the foregoing, the Company does not make any warranty that (i) access to the Platform will be timely, secure, uninterrupted, exception free; (ii) the Platform will meet your requirements; (iii) defects, if any will be corrected; (iv) the Platform will be free of any malicious software, viruses, trojans, worms or logic bombs; or (v) the results obtained from the user of the Platform will be accurate and/or reliable. You understand and agree that the Company shall not be responsible or liable for any material and/or data obtained or downloaded through the use of the Platform. Your use of the Platform is at your own risk and you will be solely responsible for any damage to your computer system or loss of data that results from the download of any material and/or data from the Platform. Unless expressly stated herein, any advice or information, whether oral or written, that you obtain from the Company directly, or through this Platform, shall not create any warranty

11. AGREEMENT TO ARBITRATE
You and we each agree that any and all disputes or claims with or against any party that relate to or arise from your use of or access to the Platform, or any products or services sold, offered, or purchased through the Platform shall be resolved exclusively through final and binding arbitration, rather than in court, except that you may assert claims in small claims court, if your claims qualify. The Federal Arbitration Act governs the interpretation and enforcement of this Agreement to Arbitrate section (this “Agreement to Arbitrate”).

Prohibition of Class and Representative Actions and Non-Individualized Relief
You and we agree that each of us may bring claims that relate to or arise from your use of or access to the Platform, or any products or services sold, offered, or purchased through the Platform only on an individual basis and not as a plaintiff or class member in any purported class or representative action or proceeding, including but not limited to actions under the Telephone Consumer Protection Act, 47 U.S.C. § 227 et seq. or the California Invasion of Privacy Act, Cal. Penal Code § 630 et seq. Unless both parties agree otherwise, the arbitrator may not preside over any form of a consolidated, class, or representative proceeding or otherwise consolidate or join claims from more than one person or party. The arbitrator may grant injunctions or other relief, including monetary, and declaratory relief, only in favor of the individual party seeking such relief and only to such extent as may be necessary to provide relief necessitated by that party’s individual claim(s). No relief awarded shall affect our other users.

Arbitration Procedures
The arbitrator, and not any federal, state, or local court or agency, shall have exclusive authority to resolve any dispute arising out of or relating to the interpretation, applicability, enforceability or formation of this Agreement to Arbitrate, any part of it, or of this Agreement including, but not limited to, any claim that all or any part of the Agreement to Arbitrate or this Agreement is void or voidable.

The arbitration will be conducted by the American Arbitration Association (“AAA”) under its rules and procedures, including the AAA’s Supplementary Procedures for Consumer-Related Disputes (as applicable), as modified by this Agreement to Arbitrate. The AAA’s rules and a form for initiating arbitration proceedings is available on the AAA’s site at http://www.adr.org.

The arbitration shall be held in the county of your residence or at another location mutually agreed by both parties. If the value of the relief sought is less than or equal to $10,000, either party may elect to have the arbitration conducted by telephone or based solely on written submissions and such election shall be binding on both parties subject to the arbitrator’s discretion to necessitate an in-person hearing, if the circumstances warrant. Unless the arbitrator requires otherwise, either party may attend an in-person hearing by telephone.

The arbitrator shall determine the substance of all claims in accordance with the applicable laws of the State of Missouri, including recognized principles of equity, and will honor all claims of privilege recognized by law. The arbitrator shall not be bound by rulings in prior arbitrations involving our other users but is bound by rulings in prior arbitrations involving the same user to the extent required by applicable law. The award of the arbitrator shall be final and binding and judgment upon the award rendered by the arbitrator may be confirmed or entered in any court having competent jurisdiction thereof.

This arbitration provision shall survive termination of this Agreement to Arbitrate and the closing of your account (if applicable) or your use of or access to the Platform, or any products or services sold, offered, or purchased through the Platform.

Costs of Arbitration
Unless otherwise stated in this Agreement to Arbitrate, all payments related to filing, administration and arbitrator fees (Arbitration Costs) will be governed by the AAA’s rules Where the value of the relief sought is less than or equal to $10,000 the Company may, at your request, pay all filing, administration, and arbitrator fees related to the arbitration. We will make arrangements to pay the Arbitration Costs to AAA only for those requests that are submitted, along with demand for arbitration, by mail to the AAA. Where the value of the relief sought is over $10,000 and you are successful in demonstrating that the costs of arbitration will be prohibitive as compared to the costs of litigation, we will pay as much of Arbitration Costs as may be deemed necessary by the arbitrator to prevent the arbitration from being cost-prohibitive. If the arbitrator determines your claim(s) in the arbitration to be frivolous, you agree that you will be liable to reimburse us for all the Arbitration Costs paid by us on your behalf, which you otherwise would be required to pay under the AAA’s rules.

Costs of Arbitration
Unless otherwise stated in this Agreement to Arbitrate, all payments related to filing, administration and arbitrator fees (Arbitration Costs) will be governed by the AAA’s rules Where the value of the relief sought is less than or equal to $10,000 the Company may, at your request, pay all filing, administration, and arbitrator fees related to the arbitration. We will make arrangements to pay the Arbitration Costs to AAA only for those requests that are submitted, along with demand for arbitration, by mail to the AAA. Where the value of the relief sought is over $10,000 and you are successful in demonstrating that the costs of arbitration will be prohibitive as compared to the costs of litigation, we will pay as much of Arbitration Costs as may be deemed necessary by the arbitrator to prevent the arbitration from being cost-prohibitive. If the arbitrator determines your claim(s) in the arbitration to be frivolous, you agree that you will be liable to reimburse us for all the Arbitration Costs paid by us on your behalf, which you otherwise would be required to pay under the AAA’s rules.

Severability
Except for the “Prohibition of Class and Representative Actions and Non-Individualized Relief” provision of this Agreement to Arbitrate, if an arbitrator or court decides that any part of this Agreement to Arbitrate is invalid or unenforceable, the other parts of this Agreement to Arbitrate shall remain in full force and effect. Where an arbitrator or court decides that any of the provision(s) in Section 1 of this Agreement to Arbitrate (i.e. “Prohibition of Class and Representative Actions and Non-Individualized Relief”) is invalid or unenforceable, then the entire Agreement to Arbitrate shall be null and void. The validity, legality and enforceability of the remainder of the Agreement shall not in any way be affected or impaired thereby.

12. Consent to Contact
You agree that providing your telephone number in any submission on the Platform where you provide your signature expressly consenting to contact from the Company its subsidiaries, affiliates, or agents, and up to 30 of its Marketing Partners at the number provided by you regarding products or services via live, automated or pre-recorded telephone call, text, or email. You understand that your telephone company may impose charges on you for these contacts, and you are not required to enter into this agreement as a condition of any purchase. You understand that you can revoke this consent through any reasonable means.

By submitting your email address, you are extending an express invitation to each third-party you have been matched with to contact you by email at any email address you provided. You agree that any such email from a third-party will not be considered spam or unauthorized by any local, state or federal law or regulation. For any service, you represent that all of the information provided by you in your submission is true and accurate.

13. VOICE RECORDING AND MONITORING CONSENT
You agree and consent that the Company may record or monitor communications made by you during any calls you make to the Platform as permitted by 18 U.S.C. § 2511 et seq., Cal. Penal Code § 630 et seq., and other state laws that regulate call monitoring and recording. By calling us, you expressly consent and grant us the right to monitor or record the calls and use this information for the purposes described in the Privacy Policy. We are not obligated to monitor or record our services for accuracy, completeness, or quality.

14. DMCA POLICY AND NOTICE
If you are a copyright owner, authorized to act on behalf of one, or authorized to act under any exclusive right under copyright, you can report alleged copyright infringements taking place on or through the Platform by completing a DMCA notice of alleged infringement, as described below, and submitting it to our Designated Agent. Upon receipt of notice, we will take suitable action that we, in our sole discretion, deem appropriate, including removal of the challenged content or material from the Platform.

Details of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works are covered by the notice, a representative list of all such works;


Identification of the content or material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which needs to be disabled, and information reasonably sufficient to allow us to locate the such content;


A declaration that the complainant in good faith believes that use of the content or material in the manner complained of is not authorized by the copyright owner, its agent, or the law;


A declaration that the information in the notification is true and correct, and that the complainant is authorized to act on behalf of the owner of an exclusive right that is allegedly infringed;


The full name and electronic or physical signature of the authorized person acting on behalf of the owner of an exclusive right that is allegedly infringed; and


Contact details of the complainant, such as email address, telephone number and an address at which the complaining party could be contacted.


Any notice of claimed infringement, including all the above-mentioned details, should be sent to our Designated Agent at info@kingfishergo.com

Please be informed that if you fail to comply with all of the requirements of this section and of 17 USC § 512(c)(3) your DMCA notice may not be valid.

15. LIMITATION ON LIABILITY
You expressly understand and agree that the Company, its agents, suppliers, parents, subsidiaries, representatives or affiliates shall, under no circumstances, be liable for any special, indirect, incidental, exemplary or consequential damages, including without limitation, any loss of use, profits, data, goodwill, cost of procurement of substitute services, or any other special, indirect, incidental, exemplary or consequential damages. This applies regardless of the manner in which damages occurred, and on any theory of liability, whether for breach of contract, tort (including, without limitation, negligence and strict liability) or otherwise resulting from (1) your use of, or the inability to use, the Platform, (2) the use of, or the inability to use, items purchased from third-party websites linked on the Platform; (3) the cost of procurement of substitute services or items; or (4) any other matter related to the Platform.

16. INDEMNIFICATION
You agree to indemnify and hold harmless the Company, its directors, officers, employees, agents, parents, subsidiaries, affiliates, co-branders, and suppliers, from and against any and all claims, demands, liability, losses, disputes, damages, and costs of any kind, including but not limited to reasonable attorneys' fees and litigation costs resulting from or in any way connected with (i) your use of the Platform; (ii) any information transmitted or submitted through the Platform; (iii) privacy, tort or other claims (e.g., claims made under the Telephone Consumer Protection Act (TCPA) or its equivalent state law ) relating to any personal information provided (e.g., telephone number) to the Company by you that is not owned by you, in contravention to the terms of this Agreement; and/or (iv) your breach of the terms of this Agreement.

17. MODIFICATIONS TO THE AGREEMENT
We reserve the right to make changes to these Terms, from time to time, in our sole discretion, by updating this posting on the Platform without prior notice to you. Your continued use of the Platform post the modification of the Terms constitutes your acceptance of such updated Terms., We encourage you to review the Terms whenever you visit the Platform, to see if a new version has been posted.

18. MISCELLANEOUS
The Company may assign, transfer, or sub-contract any of our rights or obligations under these Terms and Conditions to any third party at our discretion. Any representations, warranties, and indemnification obligations made or undertaken by you will survive cancellation or termination of your account or relationship with the Company. No delay by the Company in exercising any right or remedy under these Terms and Conditions shall operate as a waiver of that right or remedy or shall affect the Company’s ability to subsequently exercise that right or remedy. Any waiver must be agreed to by the Company in writing. These Terms and Conditions supersede any other terms previously published by us and any other representations or statements made by us to you, whether oral, written, or otherwise.

19. CONTACT US
If you have any questions or concerns about this Agreement, please contact us at info@kingfishergo.com .

''',
            style: context.textStyle.bodySmall,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: router.pop,
        icon: Icon(
          Icons.adaptive.arrow_back,
          color: Colors.white54,
        ),
        iconSize: 20,
      ),
    );
  }
}
